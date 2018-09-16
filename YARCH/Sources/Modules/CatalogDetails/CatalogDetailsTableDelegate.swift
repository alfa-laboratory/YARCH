import UIKit

class CatalogDetailsTableDelegate: NSObject, UITableViewDelegate {

    weak var delegate: CatalogDetailsViewControllerDelegate?

    let application: UIApplication

    var representableViewModels: [CatalogDetailsCellRepresentable]

    init(application: UIApplication = UIApplication.shared, viewModels: [CatalogDetailsCellRepresentable] = []) {
        self.application = application
        representableViewModels = viewModels
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        guard let coinSnapshotPropertyViewModel = representableViewModels[safe: indexPath.row] as? CoinSnapshotPropertyViewModel else { return }
        delegate?.openExternalLink(coinSnapshotPropertyViewModel.type)
    }
}
