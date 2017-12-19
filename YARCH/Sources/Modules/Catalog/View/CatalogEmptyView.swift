import UIKit
import SnapKit

class CatalogEmptyView: UIView {
    class Appearance {
        let titleColor = UIColor.black

        let subtitleColor = UIColor.gray

        let backgroundColor = UIColor.white

        let titleInsets = UIEdgeInsets(top: 0, left: 33, bottom: 0, right: 32)
        let subtitleInsets = UIEdgeInsets(top: 8, left: 33, bottom: 8, right: 32)

        var needsTopOffset = false
        var needsBottomOffset = false

    }

    fileprivate(set) lazy var view: UIView = {
        let view = UIView()
        view.backgroundColor = self.appearance.backgroundColor
        return view
    }()

    fileprivate(set) lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = self.appearance.titleColor
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    fileprivate(set) lazy var subtitle: UILabel = {
        let label = UILabel()
        label.textColor = self.appearance.subtitleColor
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let appearance: Appearance

    init(frame: CGRect = .zero, appearance: Appearance = Appearance()) {
        self.appearance = appearance
        super.init(frame: frame)
        backgroundColor = appearance.backgroundColor
        addSubviews()
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviews() {
        addSubview(view)
        view.addSubview(title)
        view.addSubview(subtitle)
    }

    func makeConstraints() {
        view.snp.makeConstraints { make in
            make.left.right.centerY.equalToSuperview()
        }

        title.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(appearance.titleInsets)
        }

        subtitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(appearance.subtitleInsets.top)
            make.left.right.bottom.equalToSuperview().inset(appearance.subtitleInsets)
        }
    }
}
