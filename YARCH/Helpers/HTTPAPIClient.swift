import Foundation

final class HTTPAPIClient: APIClient {

    var session: URLSession
    var baseURLString: String

    init(baseURLString: String) {
        self.baseURLString = baseURLString
        self.session = URLSession.shared
    }
}
