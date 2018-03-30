//  Простой модуль отображения данных в таблице.

import UIKit

protocol CatalogDisplayLogic: class {
	func displayItems(viewModel: Catalog.ShowItems.ViewModel)
}

protocol CatalogViewControllerDelegate: class {
    func openCoinDetails(_ coinId: UniqueIdentifier)
}

protocol CatalogViewProtocol: Presentable {
    typealias OnCoinSelect = ((UniqueIdentifier) -> Void)
    var onCoinSelect: OnCoinSelect? { get set }
    var onSignUpButtonTap: (() -> Void)? { get set }

}

class CatalogViewController: UIViewController, CatalogViewProtocol {
    var onCoinSelect: OnCoinSelect?
    var onSignUpButtonTap: (() -> Void)?

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

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(didTapLogoutButton))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
    }

	// MARK: Fetching
	func fetchItems() {
		let request = Catalog.ShowItems.Request()
		interactor.fetchItems(request: request)
	}

    // MARK: - Actions
    @objc private func didTapLogoutButton() {

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.black
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { _ in }))
        alert.addAction(UIAlertAction.init(title: "Logout", style: .destructive, handler: { [weak self] _ in
            self?.onSignUpButtonTap?()
        }))
        self.present(alert, animated: true, completion: nil)
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
        onCoinSelect?(coinId)
    }
}

extension CatalogViewController: CatalogErrorViewDelegate {
    func reloadButtonWasTapped() {
        display(newState: .loading)
    }
}
