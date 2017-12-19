//
//  SUT: CatalogProvider
//
//  Collaborators:
//  CatalogService
//  CatalogDataStore
//

import Quick
import Nimble

@testable import YARCH

class CatalogProviderTests: QuickSpec {
	override func spec() {
		var provider: CatalogProvider!
		var serviceMock: CatalogServiceMock!
		var dataStoreMock: CatalogDataStoreMock!

		var getItemsResult: [CatalogModel]?

		beforeEach {
			serviceMock = CatalogServiceMock()
			dataStoreMock = CatalogDataStoreMock()
			provider = CatalogProvider(dataStore: dataStoreMock, service: serviceMock)

            getItemsResult = nil
		}

		describe(".getItems") {
			context("cache is empty") {
				beforeEach {
					dataStoreMock.models = nil
				}

				it ("should request data from service") {
					// when
					provider.getItems { (_) in }
					// then
					expect(serviceMock.fetchItemsDidCalled).to(equal(1))
				}

				context("successfull response") {
					it("should save data to store") {
						// given
						serviceMock.fetchItemsCompletionStub = TestData.responseData
						// when
						provider.getItems { (_) in }
						// then
						expect(dataStoreMock.models).to(equal(TestData.responseData))
					}

					it("should return result in callback") {
						// given
						serviceMock.fetchItemsCompletionStub = TestData.responseData
						// when
						provider.getItems { getItemsResult = $0 }
						// then
						expect(getItemsResult).to(equal(TestData.responseData))
					}
				}

				context("failed response") {
					it("should not update store") {
						// given
						serviceMock.fetchItemsCompletionStub = nil
						// when
						provider.getItems { (_) in }
						// then
						expect(dataStoreMock.models).to(beNil())
					}

					it("should return error in callback") {
						// given
						serviceMock.fetchItemsCompletionStub = nil
						// when
						provider.getItems { getItemsResult = $0 }
						// then
						expect(getItemsResult).to(beNil())
					}
				}
			}
		}

		context("cache fulfilled") {
			it("should not call service") {
				// given
				dataStoreMock.models = TestData.responseData
				// when
				provider.getItems { (_) in }
				// then
				expect(serviceMock.fetchItemsDidCalled).to(equal(0))
			}

			it("should return data in callback") {
				// given
				dataStoreMock.models = TestData.responseData
				// when
				provider.getItems { getItemsResult = $0 }
				// then
				expect(getItemsResult).to(equal(TestData.responseData))
			}
		}
	}
}

extension CatalogProviderTests {
	enum TestData {
		static let responseData = CatalogModelTests.TestData.entitiesCollection()
	}
}

private class CatalogServiceMock: FetchesCatalogItems {
	var fetchItemsDidCalled: Int = 0
	var fetchItemsArguments: (([CatalogModel]?) -> Void)?
	var fetchItemsCompletionStub: [CatalogModel]?

	func fetchItems(completion: @escaping ([CatalogModel]?) -> Void) {
		fetchItemsDidCalled += 1
		fetchItemsArguments = completion
		completion(fetchItemsCompletionStub)
	}
}

private class CatalogDataStoreMock: StoresCatalogModels {
	var models: [CatalogModel]?
}

private class ErrorMock: Error {}
