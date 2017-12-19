//  Простой модуль отображения данных в таблице.

import UIKit

protocol CatalogPresentationLogic {
	func presentItems(response: Catalog.ShowItems.Response)
}

/// Отвечает за отображение данных модуля Catalog
class CatalogPresenter: CatalogPresentationLogic {

	weak var viewController: CatalogDisplayLogic?
    let errorMessage = "Error loading data 💩"
    let emptyTitle = "Nothing to do here 🚀"
    let subtitleText = "Maybe later"

	// MARK: Fetching
	func presentItems(response: Catalog.ShowItems.Response) {
		var viewModel: Catalog.ShowItems.ViewModel
		switch response.result {
		case .failure:
			viewModel = Catalog.ShowItems.ViewModel(state: .error(message: errorMessage))
		case let .success(result):
			if result.isEmpty {
				viewModel = Catalog.ShowItems.ViewModel(state: .emptyResult(title: emptyTitle, subtitle: subtitleText))
			} else {
                let cellViewModels = viewModels(from: result)
				viewModel = Catalog.ShowItems.ViewModel(state: .result(cellViewModels))
			}
		}
		viewController?.displayItems(viewModel: viewModel)
	}

    func viewModels(from models: [CatalogModel]) -> [CatalogViewModel] {
        var viewModels = [CatalogViewModel]()
        for model in models {
            let viewModel = CatalogViewModel(uid: model.uid, title: model.coinName)
            viewModels.append(viewModel)
        }
        return viewModels
    }
}
