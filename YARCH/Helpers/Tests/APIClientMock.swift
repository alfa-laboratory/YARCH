import Foundation

@testable import YARCH

class APIClientMock<T>: APIClient {

    var session = URLSession(configuration: .default)
    var baseURLString = "http://www.example.com"

    var executeDidCalled: Int = 0
    var executeCallbackStub: Result<T>?

    func task(with request: URLRequest, completion: @escaping (Result<T>) -> Void) {
        executeDidCalled += 1
        executeCallbackStub.map { completion($0) }
    }
}
