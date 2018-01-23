//  Простой модуль отображения данных в таблице.

import WatchKit

protocol CatalogDisplayLogic: class {
    func displayItems(viewModel: Catalog.ShowItems.ViewModel)
}

class CatalogInterfaceController: WKInterfaceController {
    let interactor: CatalogBusinessLogic
    var state: Catalog.ViewControllerState
    
    init(interactor: CatalogBusinessLogic, initialState: Catalog.ViewControllerState = .loading) {
        self.interactor = interactor
        self.state = initialState
        super.init()
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        display(newState: state)
    }
    
    // MARK: Fetching
    func fetchItems() {
        let request = Catalog.ShowItems.Request()
        interactor.fetchItems(request: request)
    }
}

extension CatalogInterfaceController: CatalogDisplayLogic {
    func displayItems(viewModel: Catalog.ShowItems.ViewModel) {
        display(newState: viewModel.state)
    }
    
    func display(newState: Catalog.ViewControllerState) {
        state = newState
        switch state {
        case .loading:
            fetchItems()
        case let .error(message):
            print("error \(message)")
        case let .result(items):
            print("result: \(items)")
        case .emptyResult:
            print("empty result")
        }
    }
}

