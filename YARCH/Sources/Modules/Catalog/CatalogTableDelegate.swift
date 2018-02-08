import UIKit

class CatalogTableDelegate: NSObject, UITableViewDelegate {

    weak var delegate: CatalogViewControllerDelegate?

    var representableViewModels: [CatalogViewModel]

    init(viewModels: [CatalogViewModel] = []) {
        representableViewModels = viewModels
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        guard let viewModel = representableViewModels[safe: indexPath.row] else { return }
        delegate?.openCoinDetails(viewModel.uid)
    }
}
