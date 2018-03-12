import UIKit

extension CatalogDetailsTableDataSource {
    enum Configuration {
        static let numberOfSections: Int = 1
    }
}

class CatalogDetailsTableDataSource: NSObject, UITableViewDataSource {

    var representableViewModels: [CatalogDetailsCellRepresentable]

    init(viewModels: [CatalogDetailsCellRepresentable] = []) {
        representableViewModels = viewModels
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return representableViewModels.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return Configuration.numberOfSections
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithRegistration(type: CatalogDetailsCell.self, indexPath: indexPath)
        if let cellRepresentable = representableViewModels[safe: indexPath.row] {
            cell.configure(cellRepresentable: cellRepresentable)
        }
        return cell
    }

}
