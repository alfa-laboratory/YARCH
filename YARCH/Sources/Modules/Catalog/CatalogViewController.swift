//  Простой модуль отображения данных в таблице.

import UIKit

protocol CatalogDisplayLogic: class {
	func displayItems(viewModel: Catalog.ShowItems.ViewModel)
}

protocol CatalogViewControllerDelegate: class {
    func openCoinDetails(_ coinId: UniqueIdentifier)
}

class CatalogViewController: UIViewController {
	let interactor: CatalogBusinessLogic
	var state: Catalog.ViewControllerState

    var loadingTableDataSource: UITableViewDataSource
    var loadingTableHandler: UITableViewDelegate

    lazy var customView = self.view as? CatalogView

    var tableDataSource: CatalogTableDataSource = CatalogTableDataSource()
    var tableHandler: CatalogTableDelegate = CatalogTableDelegate()

    init(title: String, interactor: CatalogBusinessLogic, loadingDataSource: UITableViewDataSource, loadingTableDelegate: UITableViewDelegate, initialState: Catalog.ViewControllerState = .loading) {
        self.interactor = interactor
        self.state = initialState
        self.loadingTableDataSource = loadingDataSource
        self.loadingTableHandler = loadingTableDelegate
        super.init(nibName: nil, bundle: nil)
        tableHandler.delegate = self
        self.title = title
    }

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: View lifecycle
	override func loadView() {
        let view = CatalogView(frame: UIScreen.main.bounds,
                                loadingDataSource: loadingTableDataSource,
                                loadingDelegate: loadingTableHandler,
                                refreshDelegate: self)
        self.view = view
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		display(newState: state)
	}

	// MARK: Fetching
	func fetchItems() {
		let request = Catalog.ShowItems.Request()
		interactor.fetchItems(request: request)
	}
}

extension CatalogViewController: CatalogDisplayLogic {
	func displayItems(viewModel: Catalog.ShowItems.ViewModel) {
		display(newState: viewModel.state)
    }

    func display(newState: Catalog.ViewControllerState) {
        state = newState
        switch state {
        case .loading:
            customView?.showLoading()
            fetchItems()
        case let .error(message):
            customView?.showError(message: message)
        case let .result(items):
            tableHandler.representableViewModels = items
            tableDataSource.representableViewModels = items
            customView?.updateTableViewData(delegate: tableHandler, dataSource: tableDataSource)
        case let .emptyResult(title, subtitle):
            customView?.showEmptyView(title: title, subtitle: subtitle)
        }
    }
}

extension CatalogViewController: CatalogViewControllerDelegate {
    func openCoinDetails(_ coinId: UniqueIdentifier) {
        let detailsController = CatalogDetailsBuilder().set(initialState: .initial(id: coinId)).build()
        navigationController?.pushViewController(detailsController, animated: true)
    }
}

extension CatalogViewController: CatalogErrorViewDelegate {
    func reloadButtonWasTapped() {
        display(newState: .loading)
    }
}
