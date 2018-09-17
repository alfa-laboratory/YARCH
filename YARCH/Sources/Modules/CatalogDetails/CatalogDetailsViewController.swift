//  Модуль детальной информации

import UIKit
#if !(os(tvOS))
import SafariServices
#endif

protocol CatalogDetailsDisplayLogic: class {
	func displayFetchedDetails(viewModel: CatalogDetails.ShowDetails.ViewModel)
    func displayOpenExtenalLink(viewModel: CatalogDetails.OpenExternalLink.ViewModel)
}

protocol CatalogDetailsViewControllerDelegate: class {
    func openExternalLink(_ linkType: CoinSnapshotPropertyType)
    func presentSafariViewController(_ url: URL)
}

class CatalogDetailsViewController: UIViewController {

    let interactor: CatalogDetailsBusinessLogic

    weak var customNavigationController: UINavigationController?

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

    var loadingTableDataSource: UITableViewDataSource
    var loadingTableHandler: UITableViewDelegate

    override var navigationController: UINavigationController? {
        return customNavigationController ?? super.navigationController
    }

    var customView: CatalogDetailsView? {
        return view as? CatalogDetailsView
    }

    var tableDataSource: CatalogDetailsTableDataSource = CatalogDetailsTableDataSource()
    var tableHandler: CatalogDetailsTableDelegate = CatalogDetailsTableDelegate()

    init(interactor: CatalogDetailsBusinessLogic,
         initialState: CatalogDetails.ViewControllerState,
         loadingDataSource: UITableViewDataSource = LoadingTableViewDataSource(),
         loadingTableDelegate: UITableViewDelegate = LoadingTableViewDelegate(), customNavigationController: UINavigationController? = nil) {

        self.interactor = interactor
        self.state = initialState
        self.loadingTableDataSource = loadingDataSource
        self.loadingTableHandler = loadingTableDelegate
        self.customNavigationController = customNavigationController
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

    func applyLoadingState(id: UniqueIdentifier) {
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
        let request = CatalogDetails.ShowDetails.Request(coinId: coinId)
		interactor.fetchDetails(request: request)
	}
}

extension CatalogDetailsViewController: CatalogDetailsDisplayLogic {

	func displayFetchedDetails(viewModel: CatalogDetails.ShowDetails.ViewModel) {
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
            #if !(os(tvOS))
            let safariViewController = SFSafariViewController(url: url)
            navigationController?.present(safariViewController, animated: true, completion: nil)
            #endif
            return
        } else if let error = viewModel.error {
            errorMessage = error.localizedDescription
        }
        let alertController = UIAlertController(title: errorMessage, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        alertController.popoverPresentationController?.sourceView = view
        navigationController?.present(alertController, animated: true, completion: nil)
    }
}

extension CatalogDetailsViewController: CatalogDetailsViewControllerDelegate {
    func openExternalLink(_ linkType: CoinSnapshotPropertyType) {
        guard case let .result(snapshotViewModel: viewModel, infoRepresentable: _) = state else { return }
        switch linkType {
        case .website:
           interactor.openExternalLink(request: .init(coinId: viewModel.uid, type: .website))
        case .twitter:
            interactor.openExternalLink(request: .init(coinId: viewModel.uid, type: .twitter))
        case .percentMined, .blockReward:
            break
        }
    }

    func presentSafariViewController(_ url: URL) {
        #if !(os(tvOS))
        let safariViewController = SFSafariViewController(url: url)
        navigationController?.present(safariViewController, animated: true, completion: nil)
        #endif
    }
}

extension CatalogDetailsViewController: CatalogErrorViewDelegate {
    func reloadButtonWasTapped() {
        state = .loading
    }
}
