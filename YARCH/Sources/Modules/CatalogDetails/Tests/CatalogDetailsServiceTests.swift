//
//  SUT: CatalogDetailsService
//
//  Collaborators:
//  APIClientMock
//  CatalogDetailsTranslator
//  JSONDecoder
//
import Quick
import Nimble

@testable import YARCH

class CatalogDetailsServiceTests: QuickSpec {
	override func spec() {

        var apiClient: APIClientMock<Any>!
        var decoder: JSONDecoderMock!
        var service: CatalogDetailsServiceProtocol!
        var fetchItemsRequestResult: Result<CoinSnapshotFullModel>?
        var completionCalledExpectation: XCTestExpectation!

        beforeEach {
            completionCalledExpectation = self.expectation(description: "Completion called")
            apiClient = APIClientMock()
            decoder = JSONDecoderMock()
            service = CatalogDetailsService(apiClient: apiClient, decoder: decoder)

        }

        describe(".fetchItems") {
            context("successful response") {
                it("should call decoder") {
                    // given
                    decoder.decodeStub = TestData.coinSnapshotWrapper
                    apiClient.executeCallbackStub = .success(TestData.fetchItemsSuccessfulResponse)

                    // when
                    service.fetchItems(coinId: TestData.coinId, completion: { _ in
                        completionCalledExpectation.fulfill()
                    })

                    // then
                    self.waitForExpectations(timeout: 1.0, handler: { error in
                        expect(error).to(beNil())
                        expect(decoder.decodeDidCalled).to(equal(1))
                    })
                }
                it("should return expected model from decoder") {
                    // given
                    decoder.decodeStub = TestData.coinSnapshotWrapper
                    apiClient.executeCallbackStub = .success(TestData.fetchItemsSuccessfulResponse)

                    // when
                    service.fetchItems(coinId: TestData.coinId, completion: { _ in
                        completionCalledExpectation.fulfill()
                    })

                    // then
                    self.waitForExpectations(timeout: 1.0, handler: { error in
                        expect(error).to(beNil())
                        expect(decoder.decodeStub).to(beAnInstanceOf(CoinSnapshotFullResponseWrapper.self))
                    })
                }
                it("should get successful response") {
                    // given
                    decoder.decodeStub = TestData.coinSnapshotWrapper
                    apiClient.executeCallbackStub = .success(TestData.fetchItemsSuccessfulResponse)

                    // when
                    service.fetchItems(coinId: TestData.coinId, completion: {
                        fetchItemsRequestResult = $0
                        completionCalledExpectation.fulfill()
                    })

                    // then
                    self.waitForExpectations(timeout: 1.0, handler: { error in
                        expect(error).to(beNil())
                        expect(fetchItemsRequestResult).to(beSuccessfull(test: {
                            expect($0).to(equal(TestData.successModel))
                        }))
                    })
                }
                it("should return incorrect decodable object in case of decoding failure") {
                    // given
                    decoder.decodeStub = TestData.decodableMock
                    apiClient.executeCallbackStub = .success(TestData.fetchItemsSuccessfulResponse)

                    // when
                    service.fetchItems(coinId: TestData.coinId, completion: {
                        fetchItemsRequestResult = $0
                        completionCalledExpectation.fulfill()
                    })

                    // then
                    self.waitForExpectations(timeout: 1.0, handler: { error in
                        expect(error).to(beNil())
                        expect(decoder.decodeDidCalled).to(equal(1))
                        expect(decoder.decodeStub).toNot(beAnInstanceOf(CoinSnapshotFullResponseWrapper.self))
                        expect(fetchItemsRequestResult).to(beFailure(test: {
                            expect($0).to(beAnInstanceOf(CatalogDetailsError.self))
                        }))
                    })
                }
            }
            context("failure response") {
                it("should call decoder") {
                    // given
                    apiClient.executeCallbackStub = .failure(CatalogDetailsError.otherLogicError)

                    // when
                    service.fetchItems(coinId: TestData.coinId, completion: { _ in
                        completionCalledExpectation.fulfill()
                    })

                    // then
                    self.waitForExpectations(timeout: 1.0, handler: { error in
                        expect(error).to(beNil())
                        expect(decoder.decodeDidCalled).to(equal(1))
                    })
                }
                it("should return error in case of failure response") {
                    // given
                    apiClient.executeCallbackStub = .failure(CatalogDetailsError.otherLogicError)

                    // when
                    service.fetchItems(coinId: TestData.coinId, completion: {
                        fetchItemsRequestResult = $0
                        completionCalledExpectation.fulfill()
                    })

                    // then
                    self.waitForExpectations(timeout: 1.0, handler: { error in
                        expect(error).to(beNil())
                        expect(fetchItemsRequestResult).to(beFailure(test: {
                            expect($0).to(beAnInstanceOf(CatalogDetailsError.self))
                        }))
                    })
                }
            }
        }

	}
}

fileprivate extension CatalogDetailsServiceTests {
    enum TestData {
        static let coinId = "1"
        static let fetchItemsSuccessfulResponse = Data()
        static let successModel = CoinSnapshotFullResponseModelTests.TestData.constantUidModel
        static let coinSnapshotWrapper = CoinSnapshotFullResponseWrapper(model: successModel)
        static let decodableMock = DecodableMock(value: "value")
    }
}

private class JSONDecoderMock: JSONDecoder {

    var decodeDidCalled: Int = 0
    var decodeStub: Any?

    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        decodeDidCalled += 1
        if let decodeStub = decodeStub as? T {
            return decodeStub
        } else {
            throw ErrorMock()
        }
    }
}

private struct DecodableMock: Decodable {
    let value: String

    private enum CodingKeys: String, CodingKey {
        case value
    }
}

private class ErrorMock: Error {}

// MARK: Custom Matchers

func beSuccessfull(test: @escaping (CoinSnapshotFullModel) -> Void = { _ in }) -> Predicate<(Result<CoinSnapshotFullModel>)> {
    return Predicate.define("be <successful>", matcher: { expr, message in
        if let actual = try expr.evaluate(), case let .success(coinSnapshotFullModel) = actual {
            test(coinSnapshotFullModel)
            return PredicateResult(status: .matches, message: message)
        }
        return PredicateResult(status: .fail, message: message)
    })
}

func beFailure(test: @escaping (CatalogDetailsError) -> Void = { _ in }) -> Predicate<(Result<CoinSnapshotFullModel>)> {
    return Predicate.define("be <successful>", matcher: { expr, message in
        if let actual = try expr.evaluate(), case let .failure(error) = actual, let catalogDetailsError = error as? CatalogDetailsError {
            test(catalogDetailsError)
            return PredicateResult(status: .matches, message: message)
        }
        return PredicateResult(status: .fail, message: message)
    })
}
