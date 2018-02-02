import Foundation

/// Получает данные для модуля Catalog
protocol FetchesCatalogItems {
    func fetchItems(completion: @escaping ([CatalogModel]?) -> Void)
}

class CatalogService: FetchesCatalogItems {
    let apiClient: APIClient
	let decoder: JSONDecoder

    init(apiClient: APIClient = APIClientProvider.shared.client(type: .cryptocompareMin),
         decoder: JSONDecoder = JSONDecoder()) {
        self.apiClient = apiClient
		self.decoder = decoder
    }

    func fetchItems(completion: @escaping ([CatalogModel]?) -> Void) {
        apiClient.get(endPoint: "all/coinlist") { (result: Result<Data>) in
            switch result {
            case let .success(data):
                let models = self.parseSuccessData(data: data)
                completion(models)
            case .failure:
                completion(nil)
            }
        }
    }

    private func parseSuccessData(data: Data) -> [CatalogModel]? {
        do {
            let model = try decoder.decode(ResponseModel.self, from: data)
			return model.data.map { $1 }
        } catch {
            return nil
        }
    }
}
