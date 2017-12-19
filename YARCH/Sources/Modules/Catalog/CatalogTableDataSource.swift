import UIKit

class CatalogTableDataSource: NSObject, UITableViewDataSource {
    var representableViewModels: [CatalogViewModel]

    init(viewModels: [CatalogViewModel] = []) {
        representableViewModels = viewModels
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return representableViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithRegistration(type: CatalogCell.self, indexPath: indexPath)
        guard let viewModel = representableViewModels[safe: indexPath.row] else { return cell }
        cell.configure(cellRepresentable: viewModel)
        return cell
    }
}
