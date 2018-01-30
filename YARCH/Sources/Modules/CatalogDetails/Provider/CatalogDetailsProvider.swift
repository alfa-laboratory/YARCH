// Провайдер получения данных модуля CatalogDetails

protocol CatalogDetailsProviderProtocol {
	func fetchDetails(coinId: String, completion: @escaping (Result<CoinSnapshotFullModel>) -> Void)
}

struct CatalogDetailsProvider: CatalogDetailsProviderProtocol {
	let dataStore: CatalogDetailsDataStore
	let service: CatalogDetailsServiceProtocol

	init(dataStore: CatalogDetailsDataStore = CatalogDetailsDataStore.shared, service: CatalogDetailsServiceProtocol = CatalogDetailsService()) {
		self.dataStore = dataStore
		self.service = service
	}

    func fetchDetails(coinId: String, completion: @escaping (Result<CoinSnapshotFullModel>) -> Void) {
		if let coinModel = dataStore.coinModels[coinId] {
			return completion(Result.success(coinModel))
		}
        service.fetchItems(coinId: coinId) {
            if case let .success(model) = $0 {
                self.dataStore.coinModels[coinId] = model
                completion($0)
            } else {
                completion($0)
            }
        }
	}
}
