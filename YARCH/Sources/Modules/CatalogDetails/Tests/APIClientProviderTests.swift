//
// SUT: APIClientProvider
// Collaborators:
// APIClientFactory
// HTTPAPIClient
//

import Quick
import Nimble

@testable import YARCH

class APIClientProviderTests: QuickSpec {

    override func spec() {
        var apiClientFactory: APIClientFactoryMock!
        var apiProvider: APIClientProvider!

        beforeEach {
            apiClientFactory = APIClientFactoryMock()
            apiClientFactory.getHTTPClientResponseStub = TestData.apiClient
            apiProvider = APIClientProvider(apiClientFactory: apiClientFactory)
        }

        describe("APIClient initialization") {
            context("no client created yet") {
                it("cryptocompareGeneral – should create api client from scratch") {
                    // when
                    _ = apiProvider.client(type: .cryptocompareGeneral)

                    // then
                    expect(apiClientFactory.cryptocompareGeneralGetterDidCalled).to(equal(1))
                    expect(apiClientFactory.getHTTPClientDidCalled).to(equal(1))
                    expect(apiClientFactory.getHTTPClientArguments).to(equal(APIClientFactory.Configuration.cryptocompareGeneralURLString))
                    expect(apiClientFactory.cryptocompareGeneralSetterDidCalled).to(equal(1))
                }

                it("cryptocompareMin – should create api client from scratch") {
                    // when
                    _ = apiProvider.client(type: .cryptocompareMin)

                    // then
                    expect(apiClientFactory.cryptocompareMinGetterDidCalled).to(equal(1))
                    expect(apiClientFactory.getHTTPClientDidCalled).to(equal(1))
                    expect(apiClientFactory.getHTTPClientArguments).to(equal(APIClientFactory.Configuration.cryptocompareMinURLString))
                    expect(apiClientFactory.cryptocompareMinSetterDidCalled).to(equal(1))
                }

            }
            context("client already exist") {
                it("cryptocompareGeneral – should not call api client creation in case it exist") {
                    // when
                    apiClientFactory.cryptocompareGeneralGetterStub = TestData.apiClient
                    _ = apiProvider.client(type: .cryptocompareGeneral)

                    // then
                    expect(apiClientFactory.cryptocompareGeneralGetterDidCalled).to(equal(1))
                    expect(apiClientFactory.cryptocompareGeneralSetterDidCalled).to(equal(0))
                    expect(apiClientFactory.getHTTPClientDidCalled).to(equal(0))
                }
                it("cryptocompareMin – should not call api client creation in case it exist") {
                    // when
                    apiClientFactory.cryptocompareMinGetterStub = TestData.apiClient
                    _ = apiProvider.client(type: .cryptocompareMin)

                    // then
                    expect(apiClientFactory.cryptocompareMinGetterDidCalled).to(equal(1))
                    expect(apiClientFactory.cryptocompareMinSetterDidCalled).to(equal(0))
                    expect(apiClientFactory.getHTTPClientDidCalled).to(equal(0))
                }
            }
        }
    }
}

extension APIClientProviderTests {
    enum TestData {
        static let exampleURL = "http://www.example.com"
        static let apiClient = HTTPAPIClient(baseURLString: exampleURL)
    }
}

private class APIClientFactoryMock: APIClientFactory {

    var cryptocompareMinGetterDidCalled: Int = 0
    var cryptocompareMinSetterDidCalled: Int = 0
    var cryptocompareMinGetterStub: APIClient?
    var cryptocompareMinSetterValue: APIClient?

    var cryptocompareGeneralGetterDidCalled: Int = 0
    var cryptocompareGeneralSetterDidCalled: Int = 0
    var cryptocompareGeneralGetterStub: APIClient?
    var cryptocompareGeneralSetterValue: APIClient?

    override var cryptocompareMin: APIClient? {
        get {
            cryptocompareMinGetterDidCalled += 1
            return cryptocompareMinGetterStub
        }
        set {
            cryptocompareMinSetterDidCalled += 1
            cryptocompareMinSetterValue = newValue
        }
    }

    override var cryptocompareGeneral: APIClient? {
        get {
            cryptocompareGeneralGetterDidCalled += 1
            return cryptocompareGeneralGetterStub
        }
        set {
            cryptocompareGeneralSetterDidCalled += 1
            cryptocompareGeneralSetterValue = newValue
        }
    }

    var getHTTPClientDidCalled: Int = 0
    var getHTTPClientArguments: String?
    var getHTTPClientResponseStub: HTTPAPIClient?

    override func getHTTPClient(baseURLString: String) -> HTTPAPIClient {
        getHTTPClientDidCalled += 1
        getHTTPClientArguments = baseURLString
        return getHTTPClientResponseStub!
    }
}
