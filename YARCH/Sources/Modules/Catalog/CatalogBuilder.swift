// Простой модуль отображения данных в таблице.

import UIKit

class CatalogBuilder: ModuleBuilder {
    var title: String?

    func setTitle(_ title: String) -> CatalogBuilder {
        self.title = title
        return self
    }

    func build() -> UIViewController {
        guard let title = title else { fatalError("You should set a title") }
		let presenter = CatalogPresenter()
		let interactor = CatalogInteractor(presenter: presenter)
        let controller = CatalogViewController(title: title, interactor: interactor, loadingDataSource: LoadingTableViewDataSource(), loadingTableDelegate: LoadingTableViewDelegate())
		presenter.viewController = controller
		return controller
	}
}
