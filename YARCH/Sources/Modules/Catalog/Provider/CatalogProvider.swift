/// Отвечает за получение данных модуля Catalog
protocol ProvidesCatalogItems {
    func getItems(completion: @escaping ([CatalogModel]?) -> Void)
}

struct CatalogProvider: ProvidesCatalogItems {
    let dataStore: StoresCatalogModels
    let service: FetchesCatalogItems

    init(dataStore: StoresCatalogModels = CatalogDataStore.shared, service: FetchesCatalogItems = CatalogService()) {
        self.dataStore = dataStore
        self.service = service
    }

    func getItems(completion: @escaping ([CatalogModel]?) -> Void) {
        if dataStore.models?.isEmpty == false {
            return completion(self.dataStore.models)
        }
        service.fetchItems { models in
			self.dataStore.models = models
			completion(self.dataStore.models)
        }
    }
}
