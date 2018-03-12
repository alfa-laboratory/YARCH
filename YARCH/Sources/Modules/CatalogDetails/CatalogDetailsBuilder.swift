//  Модуль детальной информации

import UIKit

class CatalogDetailsBuilder: ModuleBuilder {
    var initialState: CatalogDetails.ViewControllerState?

    func set(initialState: CatalogDetails.ViewControllerState) -> CatalogDetailsBuilder {
        self.initialState = initialState
        return self
    }

    func build() -> UIViewController {
        guard let initialState = initialState else {
            fatalError("Initial state parameter was not set")
        }

        let presenter = CatalogDetailsPresenter()
        let interactor = CatalogDetailsInteractor(presenter: presenter)
        let controller = CatalogDetailsViewController(interactor: interactor,
                                                      initialState: initialState)

        presenter.viewController = controller
        return controller
    }
}
