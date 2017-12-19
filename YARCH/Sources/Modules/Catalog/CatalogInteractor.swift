//  Простой модуль отображения данных в таблице.

protocol CatalogBusinessLogic {
	func fetchItems(request: Catalog.ShowItems.Request)
}

/// Класс для описания бизнес-логики модуля Catalog
class CatalogInteractor: CatalogBusinessLogic {
	let presenter: CatalogPresentationLogic
	let provider: ProvidesCatalogItems

	init(presenter: CatalogPresentationLogic, provider: ProvidesCatalogItems = CatalogProvider()) {
		self.presenter = presenter
		self.provider = provider
	}

	// MARK: Fetching
	func fetchItems(request: Catalog.ShowItems.Request) {
		provider.getItems { items in
			let result: Result<[CatalogModel]>
			if let items = items {
				result = .success(items)
			} else {
				result = .failure(Catalog.ShowItems.Response.Error.fetchError)
            }
			self.presenter.presentItems(response: .init(result: result))
		}
	}
}
