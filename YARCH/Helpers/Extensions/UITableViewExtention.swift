import UIKit

extension UITableView {

    convenience init(delegate: UITableViewDelegate, dataSource: UITableViewDataSource, backgroundColor: UIColor = UIColor.white, estimatedRowHeight: CGFloat = 80) {
        self.init()
        self.delegate = delegate
        self.dataSource = dataSource
        self.backgroundColor = backgroundColor
        self.estimatedRowHeight = estimatedRowHeight
        self.rowHeight = UITableViewAutomaticDimension
    }
}
