import Foundation

protocol APIClient: class {

    var session: URLSession { get set }
    var baseURLString: String { get set }

    init(session: URLSession, baseURLString: String)

    func task(with request: URLRequest, completion: @escaping (Result<Any>) -> Void)
}

extension APIClient {

    init(session: URLSession = URLSession.shared, baseURLString: String) {
        self.init(session: session, baseURLString: baseURLString)
    }

    func get<T>(endPoint: String, parameters: [String: String] = [:], completion: @escaping (Result<T>) -> Void) {
        var result: Result<T>?
        defer {
            if let result = result {
                completion(result)
            }
        }
        var urlComponents = URLComponents()
        urlComponents.queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        guard let baseURL = URL(string: baseURLString) else { return result = .failure(APIClientError.invalidBaseURL) }
        guard let url = urlComponents.url(relativeTo: baseURL.appendingPathComponent(endPoint)) else { return result = .failure(APIClientError.invalidParams) }
        var request = URLRequest(url: url)
        #if (os(watchOS))
            request.cachePolicy = .reloadIgnoringLocalCacheData
        #endif
        request.httpMethod = HTTPMethod.get.rawValue
        task(with: request, completion: completion)
    }

    func task<T>(with request: URLRequest, completion: @escaping (Result<T>) -> Void){
        let task = session.dataTask(with: request) {(data, response, error) in
            let result: Result<T>
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            switch (data, error) {
            case let (.some(data), .none):
                guard let data = data as? T else { return result = .failure(APIClientError.invalidResponseDataType) }
                result = .success(data)
            case let (.none, .some(error)):
                result = .failure(APIClientError.networkError(underlyingError: error))
            case (.none, .none),
                 (.some, .some):
                result = .failure(APIClientError.invalidResponse)
            }
        }
        task.resume()
    }
}
