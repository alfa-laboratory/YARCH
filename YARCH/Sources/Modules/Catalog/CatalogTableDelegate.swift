import UIKit

class CatalogTableDelegate: NSObject, UITableViewDelegate {

    let router: Router

    var representableViewModels: [CatalogViewModel]

    init(router: Router = Router.shared, viewModels: [CatalogViewModel] = []) {
        self.router = router
        representableViewModels = viewModels
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        guard let viewModel = representableViewModels[safe: indexPath.row] else { return }
        let initialState: CatalogDetails.ViewControllerState = .initial(id: viewModel.uid)
        let detailsController = CatalogDetailsBuilder().set(initialState: initialState).build()
        router.push(detailsController, animated: true)
    }
}
