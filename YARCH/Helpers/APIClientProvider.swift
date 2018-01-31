// Провайдер API-клиентов

import Foundation

class APIClientProvider {

    enum APIClientType {
        case cryptocompareGeneral
        case cryptocompareMin
    }

    static let shared = APIClientProvider()

    let apiClientFactory: APIClientFactory

    init(apiClientFactory: APIClientFactory = APIClientFactory()) {
        self.apiClientFactory = apiClientFactory
    }

    func client(type: APIClientType) -> APIClient {
        switch type {
        case .cryptocompareGeneral:
            return apiClientFactory.getCryptocompareGeneralClient()
        case .cryptocompareMin:
            return apiClientFactory.getCryptocompareMinClient()
        }
    }

}
