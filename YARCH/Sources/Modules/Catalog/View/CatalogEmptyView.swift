import UIKit

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
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: topAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: appearance.titleInsets.left).isActive = true
        title.rightAnchor.constraint(equalTo: rightAnchor, constant: -appearance.titleInsets.right).isActive = true

        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: appearance.subtitleInsets.top).isActive = true
        subtitle.leftAnchor.constraint(equalTo: leftAnchor, constant: appearance.subtitleInsets.left).isActive = true
        subtitle.rightAnchor.constraint(equalTo: rightAnchor, constant: -appearance.subtitleInsets.right).isActive = true
        subtitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -appearance.subtitleInsets.bottom).isActive = true
    }
}
