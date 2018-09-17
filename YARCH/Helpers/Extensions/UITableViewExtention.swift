import UIKit

extension UITableView {
    
    static func defaultReuseId(for elementType: UIView.Type) -> String {
        return String(describing: elementType)
    }
    
    convenience init(delegate: UITableViewDelegate, dataSource: UITableViewDataSource, backgroundColor: UIColor = UIColor.white, estimatedRowHeight: CGFloat = 80) {
        self.init()
        self.delegate = delegate
        self.dataSource = dataSource
        self.backgroundColor = backgroundColor
        self.estimatedRowHeight = estimatedRowHeight
        self.rowHeight = UITableView.automaticDimension
    }
    
    func dequeueReusableHeaderFooterWithRegistration<T: UITableViewHeaderFooterView>(type: T.Type, reuseId: String? = nil) -> T {
        let normalizedReuseId = reuseId ?? UITableView.defaultReuseId(for: T.self)
        
        if let view = dequeueReusableHeaderFooterView(withIdentifier: normalizedReuseId) as? T {
            return view
        }
        
        register(type, forHeaderFooterViewReuseIdentifier: normalizedReuseId)
        return dequeueReusableHeaderFooterView(withIdentifier: normalizedReuseId) as! T
    }
    
    func dequeueReusableCellWithRegistration<T: UITableViewCell>(type: T.Type, indexPath: IndexPath, reuseId: String? = nil) -> T {
        let normalizedReuseId = reuseId ?? UITableView.defaultReuseId(for: T.self)
        
        if let cell = dequeueReusableCell(withIdentifier: normalizedReuseId) as? T {
            return cell
        }
        register(type, forCellReuseIdentifier: normalizedReuseId)
        return dequeueReusableCell(withIdentifier: normalizedReuseId, for: indexPath) as! T
    }
}
