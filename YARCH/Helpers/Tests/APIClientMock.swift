import Foundation

@testable import YARCH

class APIClientMock: APIClient {

    var session = URLSession(configuration: .default)
    var baseURLString = "http://www.example.com"

    var executeDidCalled: Int = 0
    var executeCallbackStub: Result<Any>?

    func task(with request: URLRequest, completion: @escaping (Result<Any>) -> Void) {
        executeDidCalled += 1
        if let executeCallbackStub = executeCallbackStub {
            completion(executeCallbackStub)
        }
    }
}
