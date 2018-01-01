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
        tableView.register(CatalogCell.self, forCellReuseIdentifier: String(describing: CatalogCell.self))
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CatalogCell.self), for: indexPath)
        guard let viewModel = representableViewModels[safe: indexPath.row],
              let catalogCell = cell as? CatalogCell else { return cell }
        catalogCell.configure(cellRepresentable: viewModel)
        return cell
    }
}
