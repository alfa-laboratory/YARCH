import UIKit

/// Делегат для таблицы в состоянии загрузки
extension LoadingTableViewDelegate {
    struct Appearance {
        var heightForSectionHeader: CGFloat = 40
    }
}

class LoadingTableViewDelegate: NSObject, UITableViewDelegate {
    let appearance: Appearance

    init(appearance: Appearance = Appearance()) {
        self.appearance = appearance
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.register(LoadingSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: LoadingSectionHeaderView.self))
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: LoadingSectionHeaderView.self))
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return appearance.heightForSectionHeader
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
