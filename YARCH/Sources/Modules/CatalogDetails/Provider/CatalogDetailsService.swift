// Сервис получения данных для модуля CatalogDetails

import Foundation

protocol CatalogDetailsServiceProtocol {
    func fetchItems(coinId: String, completion: @escaping (Result<CoinSnapshotFullModel>) -> Void)
}

enum CatalogDetailsServiceResult {
    case success(CoinSnapshotFullModel)
    case failure(CatalogDetailsError)
}

enum CatalogDetailsError: Error {
    case serializationError(String)
    case networkError(String)
    case externalURLError
    case otherLogicError

    var localizedDescription: String {
        switch self {
        case let .serializationError(message):
            return "Serialization Error:\n\(message)"
        case let .networkError(message):
            return "Network Error:\n\(message)"
        case .externalURLError:
            return "External URL is invalid"
        case .otherLogicError:
            return "Something Went Wrong"
        }
    }
}

class CatalogDetailsService: CatalogDetailsServiceProtocol {
    let apiClient: APIClient
    let decoder: JSONDecoder

    init(apiClient: APIClient = APIClientProvider.shared.client(type: .cryptocompareGeneral),
         decoder: JSONDecoder = JSONDecoder()) {
        self.apiClient = apiClient
        self.decoder = decoder
    }

    func fetchItems(coinId: String, completion: @escaping (Result<CoinSnapshotFullModel>) -> Void) {
        apiClient.get(endPoint: "coinsnapshotfullbyid", parameters: ["id": coinId]) { (result: Result<Data>) in
            switch result {
            case let .success(data):
                do {
                    let model = try self.parseSuccessData(data: data)
                    completion(Result.success(model))
                } catch let error as CatalogDetailsError {
                    completion(.failure(error))
                } catch let error {
                    let wrappedError = CatalogDetailsError.networkError(error.localizedDescription)
                    completion(.failure(wrappedError))
                }
            case let .failure(error):
                let wrappedError = CatalogDetailsError.networkError(error.localizedDescription)
                completion(.failure(wrappedError))
            }
        }
    }

    private func parseSuccessData(data: Data) throws -> CoinSnapshotFullModel {
        do {
            let wrappedModel = try decoder.decode(CoinSnapshotFullResponseWrapper.self, from: data)
            return wrappedModel.model
        } catch let error {
            throw CatalogDetailsError.serializationError(error.localizedDescription)
        }
    }
}
