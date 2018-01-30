//  Модуль детальной информации

import UIKit
import SafariServices

protocol CatalogDetailsDisplayLogic: class {
	func displayFetchedDetails(viewModel: CatalogDetails.FetchDetails.ViewModel)
    func displayOpenExtenalLink(viewModel: CatalogDetails.OpenExternalLink.ViewModel)
}

typealias CoinId = String

protocol CatalogDetailsViewControllerDelegate: class {
    func openExternalLink(_ linkType: CoinSnapshotPropertyType)
    func presentSafariViewController(_ url: URL)
}

class CatalogDetailsViewController: UIViewController {

	let interactor: CatalogDetailsBusinessLogic

    var state: CatalogDetails.ViewControllerState {
        didSet(previousState) {
            switch (previousState, state) {
            case let (.initial(coinId), .loading):
                applyLoadingState(id: coinId)
            case let (.error(id: coinId, message: _), .loading):
                applyLoadingState(id: coinId)
            case let (.loading, .error(id: _, message: message)):
                applyErrorState(message: message)
            case let (_, .result(viewModel, cellRepresentables)):
                applyResult(viewModel: viewModel, cellRepresentables: cellRepresentables)
            default:
                break
            }
        }
    }

    let router: Router

    var loadingTableDataSource: UITableViewDataSource
    var loadingTableHandler: UITableViewDelegate

    var customView: CatalogDetailsView? {
        return view as? CatalogDetailsView
    }

    var tableDataSource: CatalogDetailsTableDataSource = CatalogDetailsTableDataSource()
    var tableHandler: CatalogDetailsTableDelegate = CatalogDetailsTableDelegate()

    init(interactor: CatalogDetailsBusinessLogic,
         initialState: CatalogDetails.ViewControllerState,
         loadingDataSource: UITableViewDataSource,
         loadingTableDelegate: UITableViewDelegate,
         router: Router = Router.shared) {

		self.interactor = interactor
        self.state = initialState
        self.loadingTableDataSource = loadingDataSource
        self.loadingTableHandler = loadingTableDelegate
        self.router = router
		super.init(nibName: nil, bundle: nil)
        tableHandler.delegate = self
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: View lifecycle

	override func loadView() {
        self.view = CatalogDetailsView(frame: UIScreen.main.bounds,
                                      loadingDataSource: loadingTableDataSource,
                                      loadingDelegate: loadingTableHandler,
                                      refreshDelegate: self)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
        state = .loading
	}

    // MARK: State Updates

    func applyLoadingState(id: CoinId) {
        customView?.showLoading()
        fetchDetailInfo(coinId: id)
    }

    func applyErrorState(message: String) {
        customView?.showError(message: message)
    }

    func applyResult(viewModel: CoinSnapshotFullViewModel, cellRepresentables: [CatalogDetailsCellRepresentable]) {
        title = viewModel.title
        customView?.configureHeaderView(viewModel)
        customView?.updateTableViewData(delegate: tableHandler, dataSource: tableDataSource)
    }

	// MARK: Fetch Coin Detail Information

    func fetchDetailInfo(coinId: String) {
        let request = CatalogDetails.FetchDetails.Request(coinId: coinId)
		interactor.fetchDetails(request: request)
	}
}

extension CatalogDetailsViewController: CatalogDetailsDisplayLogic {

	func displayFetchedDetails(viewModel: CatalogDetails.FetchDetails.ViewModel) {
        if let snapshotViewModel = viewModel.snapshotViewModel, let infoRepresentable = viewModel.infoRepresentable {
            tableDataSource.representableViewModels = infoRepresentable
            tableHandler.representableViewModels = infoRepresentable
            state = .result(snapshotViewModel: snapshotViewModel, infoRepresentable: infoRepresentable)
        } else if let error = viewModel.error {
            state = .error(id: viewModel.coinId, message: error.localizedDescription)
        } else {
            state = .error(id: viewModel.coinId, message: "Something Went Wrong")
        }
	}

    func displayOpenExtenalLink(viewModel: CatalogDetails.OpenExternalLink.ViewModel) {
        var errorMessage = CatalogDetailsError.otherLogicError.localizedDescription
        if let url = viewModel.url {
            let safariViewController = SFSafariViewController(url: url)
            return router.present(safariViewController, animated: true, completion: nil)
        } else if let error = viewModel.error {
            errorMessage = error.localizedDescription
        }
        let alertController = UIAlertController(title: errorMessage, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        alertController.popoverPresentationController?.sourceView = view
        present(alertController, animated: true, completion: nil)
    }
}

extension CatalogDetailsViewController: CatalogDetailsViewControllerDelegate {
    func openExternalLink(_ linkType: CoinSnapshotPropertyType) {
        guard case let .result(snapshotViewModel: viewModel, infoRepresentable: _) = state else { return }
        switch linkType {
        case .website:
           interactor.openExternalLink(request: .init(coinId: viewModel.id, type: .website))
        case .twitter:
            interactor.openExternalLink(request: .init(coinId: viewModel.id, type: .twitter))
        case .percentMined, .blockReward:
            break
        }
    }

    func presentSafariViewController(_ url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        router.present(safariViewController, animated: true, completion: nil)
    }
}

extension CatalogDetailsViewController: CatalogErrorViewDelegate {
    func reloadButtonWasTapped() {
        state = .loading
    }
}
