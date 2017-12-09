//
//  SUT: CatalogDetailsProvider
//
//  Collaborators:
//  CatalogDetailsService
//  CatalogDetailsDataStore
//

import Quick
import Nimble

@testable import YARCH

class CatalogDetailsProviderTests: QuickSpec {
	override func spec() {
		var provider: CatalogDetailsProvider!
		var serviceMock: CatalogDetailsServiceMock!
		var dataStoreMock: CatalogDetailsDataStoreMock!

        var getItemsResult: Result<CoinSnapshotFullModel>!

		beforeEach {
			serviceMock = CatalogDetailsServiceMock()
			dataStoreMock = CatalogDetailsDataStoreMock()
			provider = CatalogDetailsProvider(dataStore: dataStoreMock, service: serviceMock)

            getItemsResult = nil
		}

		describe(".getItems") {
			context("cache is empty") {
				beforeEach {
                    dataStoreMock.coinModels = [:]
				}

				it ("should request data from service") {
                    // given
                    serviceMock.fetchItemsResponseStub = .success(TestData.responseData)

					// when
					provider.fetchDetails(coinId: TestData.coinId, completion: { _ in })

					// then
					expect(serviceMock.fetchItemsDidCalled).to(equal(1))
				}

				context("successfull response") {
					it("should save data to store") {
						// given
                        serviceMock.fetchItemsResponseStub = .success(TestData.responseData)

						// when
                        provider.fetchDetails(coinId: TestData.coinId, completion: { _ in })

						// then
						expect(dataStoreMock.coinModels[TestData.coinId]).to(equal(TestData.responseData))
					}

					it("should return result in callback") {
						// given
						serviceMock.fetchItemsResponseStub = .success(TestData.responseData)

						// when
                        provider.fetchDetails(coinId: TestData.coinId, completion: { getItemsResult = $0 })

						// then
                        expect(getItemsResult).to(beSuccessfull(test: {
                            expect($0).to(equal(TestData.responseData))
                        }))
					}
				}

				context("failed response") {
					it("should not update store") {
						// given
						serviceMock.fetchItemsResponseStub = .failure(TestData.responseError)

						// when
						provider.fetchDetails(coinId: TestData.coinId, completion: { getItemsResult = $0 })

						// then
						expect(dataStoreMock.coinModels).to(beEmpty())
					}

					it("should return error in callback") {
                        // given
                        serviceMock.fetchItemsResponseStub = .failure(TestData.responseError)

                        // when
                        provider.fetchDetails(coinId: TestData.coinId, completion: { getItemsResult = $0 })

                        // then
                        expect(getItemsResult).to(beFailure(test: {
                            expect($0).to(beAnInstanceOf(CatalogDetailsError.self))
                        }))
					}
				}
			}
		}

		context("cache fulfilled") {
			it("should not call service") {
				// given
				dataStoreMock.coinModels = TestData.cachedModels

				// when
				provider.fetchDetails(coinId: TestData.coinId, completion: { getItemsResult = $0 })

				// then
				expect(serviceMock.fetchItemsDidCalled).to(equal(0))
			}

			it("should return data in callback") {
				// given
				dataStoreMock.coinModels = TestData.cachedModels

				// when
				provider.fetchDetails(coinId: TestData.coinId, completion: { getItemsResult = $0 })

				// then
                expect(getItemsResult).to(beSuccessfull(test: {
                    expect($0).to(equal(TestData.responseData))
                }))
			}
		}
	}
}

extension CatalogDetailsProviderTests {
	enum TestData {
        static let responseData = CoinSnapshotFullResponseModelTests.TestData.constantUidModel
        static let responseError = CatalogDetailsError.otherLogicError
        static let coinId = "1"
        static let cachedModels: [String: CoinSnapshotFullModel] = [coinId: responseData]
	}
}

private class CatalogDetailsServiceMock: CatalogDetailsServiceProtocol {

    var fetchItemsDidCalled: Int = 0
    var fetchItemsArguments: String?
    var fetchItemsResponseStub: Result<CoinSnapshotFullModel>?

    func fetchItems(coinId: String, completion: @escaping (Result<CoinSnapshotFullModel>) -> Void) {
        fetchItemsDidCalled += 1
        fetchItemsArguments = coinId
        completion(fetchItemsResponseStub!)
    }

}

private class CatalogDetailsDataStoreMock: CatalogDetailsDataStore {}
