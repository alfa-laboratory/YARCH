// Фабрика API-клиентов

import Foundation

extension APIClientFactory {
    enum Configuration {
        static let cryptocompareGeneralURLString = "https://www.cryptocompare.com/api/data/"
        static let cryptocompareMinURLString = "https://min-api.cryptocompare.com/data/"
    }
}

class APIClientFactory {

    enum APIClientType {
        case cryptocompareGeneral
        case cryptocompareMin
    }

    var cryptocompareGeneral: APIClient?
    var cryptocompareMin: APIClient?

    // MARK: Constructors

    func getCryptocompareGeneralClient() -> APIClient {
        if let cryptocompareGeneral = cryptocompareGeneral {
            return cryptocompareGeneral
        }

        let apiClient = getHTTPClient(baseURLString: Configuration.cryptocompareGeneralURLString)
        cryptocompareGeneral = apiClient
        return apiClient
    }

    func getCryptocompareMinClient() -> APIClient {
        if let cryptocompareMin = cryptocompareMin {
            return cryptocompareMin
        }

        let apiClient = getHTTPClient(baseURLString: Configuration.cryptocompareMinURLString)
        cryptocompareMin = apiClient
        return apiClient
    }

    // MARK: Helpers

    func getHTTPClient(baseURLString: String) -> HTTPAPIClient {
        return HTTPAPIClient(baseURLString: baseURLString)
    }
}
