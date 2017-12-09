import UIKit

protocol CatalogErrorViewDelegate: class {
    func reloadButtonWasTapped()
}

/// Вью для состояния ошибки сетевого запроса
class CatalogErrorView: UIView {
    class Appearance {
        let titleColor = UIColor.black

        let backgroundColor = UIColor.white
        let buttonCornerRadius: CGFloat = 4
        let buttonTitleColor = UIColor.darkGray
        let buttonTitleHighlightedColor = UIColor.lightGray
        let buttonBackgroundColor = UIColor(red: 11/255, green: 31/255, blue: 53/255, alpha: 0.1)

        let titleInsets = UIEdgeInsets(top: 0.35, left: 33, bottom: 0, right: 32)
        let refreshButtonInsets = UIEdgeInsets(top: 24, left: 88, bottom: 0, right: 87)
        let refreshButtonHeight: CGFloat = 48

        let buttonText = "Try again"
    }

    weak var delegate: CatalogErrorViewDelegate?

    lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = self.appearance.titleColor
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.setTitle(self.appearance.buttonText, for: .normal)
        button.setTitleColor(self.appearance.buttonTitleColor, for: .normal)
        button.setTitleColor(self.appearance.buttonTitleHighlightedColor, for: .highlighted)
        button.addTarget(self, action: #selector(refreshButtonWasTapped), for: .touchUpInside)
        return button
    }()

    let appearance: Appearance

    init(appearance: Appearance = Appearance()) {
        self.appearance = appearance
        super.init(frame: CGRect.zero)
        backgroundColor = appearance.backgroundColor
        addSubviews()
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviews() {
        addSubview(title)
        addSubview(refreshButton)
    }

    func makeConstraints() {
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(appearance.titleInsets.left)
            make.right.equalToSuperview().offset(-appearance.titleInsets.right)
        }

        refreshButton.snp.makeConstraints { make in
            make.centerX.equalTo(title.snp.centerX)
            make.top.equalTo(title.snp.bottom).offset(appearance.refreshButtonInsets.top)
        }
    }

    @objc
    func refreshButtonWasTapped() {
        delegate?.reloadButtonWasTapped()
    }
}
