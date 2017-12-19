/// Класс для хранения данных модуля Catalog
protocol StoresCatalogModels: class {
	var models: [CatalogModel]? { get set }
}

class CatalogDataStore: StoresCatalogModels {
    static let shared = CatalogDataStore()
	var models: [CatalogModel]?
}
