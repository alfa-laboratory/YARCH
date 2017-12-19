import UIKit
import SnapKit

/// Представление заголовка секции для состояния загрузки таблицы
extension LoadingSectionHeaderView {
    struct Appearance {
        let grayViewColor = UIColor(red: 11/255, green: 31/255, blue: 52/255, alpha: 0.05)
        let grayViewInsets = UIEdgeInsets(top: 20, left: 13, bottom: 12, right: 292)
        let grayViewMinimumSize = CGSize(width: 70, height: 8)
		let rightEdgeConstraintPriority = 100
    }
}

class LoadingSectionHeaderView: UITableViewHeaderFooterView {

    let appearance = Appearance()

    lazy var grayView: UIView = {
        let view = UIView()
        view.backgroundColor = self.appearance.grayViewColor
        view.setRadius(radius: self.appearance.grayViewMinimumSize.height / 2)
        return view
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(grayView)
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeConstraints() {
        grayView.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(appearance.grayViewMinimumSize.width)
            make.top.left.equalToSuperview().inset(appearance.grayViewInsets)
            make.right.lessThanOrEqualToSuperview().offset(-appearance.grayViewInsets.right).priority(appearance.rightEdgeConstraintPriority)
            make.bottom.equalToSuperview().offset(-appearance.grayViewInsets.bottom)
        }
    }
}
