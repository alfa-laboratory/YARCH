/// Класс для хранения данных модуля CatalogDetails

class CatalogDetailsDataStore {
    static let shared = CatalogDetailsDataStore()

    var coinModels: [String: CoinSnapshotFullModel] = [:]
}
