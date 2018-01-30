//  Простой модуль отображения данных в таблице.

import WatchKit

protocol CatalogDisplayLogic: class {
    func displayItems(viewModel: Catalog.ShowItems.ViewModel)
}

class CatalogInterfaceController: WKInterfaceController {
    let interactor: CatalogBusinessLogic
    var state: Catalog.ViewControllerState
    
    @IBOutlet var statusLabel: WKInterfaceLabel!
    @IBOutlet var catalogTable: WKInterfaceTable!
    
    override init() {
        let presenter = CatalogPresenter()
        let interactor = CatalogInteractor(presenter: presenter)
        self.interactor = interactor
        self.state = .loading
        super.init()
        presenter.viewController = self
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        display(newState: state)
    }
    
    func setupTable(_ items: [CatalogViewModel]) {
        catalogTable.setNumberOfRows(items.count, withRowType: "CatalogCell")
        items.enumerated().forEach { (index, item) in
            if let row = catalogTable.rowController(at: index) as? CatalogCell {
                row.titleLabel.setText(item.title)
            }
        }
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
            statusLabel.setText("Loading...")
            fetchItems()
        case let .error(message):
            statusLabel.setText("Error: \(message)")
        case let .result(items):
            statusLabel.setHidden(true)
            catalogTable.setHidden(false)
            setupTable(items)
        case .emptyResult:
            statusLabel.setText("Empty")
        }
    }
}

