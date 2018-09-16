import UIKit
import SnapKit

///  Ячейка таблицы в состоянии загрузки
extension LoadingTableViewCell {
    struct Appearance {

        let circleInsets = UIEdgeInsets(top: 18, left: 12, bottom: 18, right: 319)
        let topInsets = UIEdgeInsets(top: 25, left: 17, bottom: 16, right: 160)
        let rightInsets = UIEdgeInsets(top: 25, left: 160, bottom: 16, right: 12)
        let bottomInsets = UIEdgeInsets(top: 16, left: 17, bottom: 23, right: 172)

        let topLineSize = CGSize(width: 70, height: 8)
        let bottomLineSize = CGSize(width: 130, height: 8)
        let rightLineSize = CGSize(width: 60, height: 8)

        let lineCornerRadius: CGFloat = 4
        let circleCornerRadius: CGFloat = 22
        let backgroundColor = UIColor(red: 11/255, green: 31/255, blue: 52/255, alpha: 0.05)

		let rightEdgeConstraintPriority = 100
    }
}

class LoadingTableViewCell: UITableViewCell {

    lazy var circle = self.configureView(radius: self.appearance.circleCornerRadius)

    lazy var topView = self.configureView(radius: self.appearance.lineCornerRadius)

    lazy var bottomView = self.configureView(radius: self.appearance.lineCornerRadius)

    lazy var rightView = self.configureView(radius: self.appearance.lineCornerRadius)

    let appearance = Appearance()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        makeConstraints()
        selectionStyle = .none
    }

    func configureView(radius: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = self.appearance.backgroundColor
        view.setRadius(radius: radius)
        return view
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        contentView.addSubview(circle)
        contentView.addSubview(topView)
        contentView.addSubview(bottomView)
        contentView.addSubview(rightView)
    }

    func makeConstraints() {
        circle.snp.makeConstraints { make in
            make.width.equalTo(circle.snp.height)
            make.top.left.bottom.equalToSuperview().inset(appearance.circleInsets)
        }

        topView.snp.makeConstraints { make in
            make.size.greaterThanOrEqualTo(appearance.topLineSize)
            make.top.equalToSuperview().offset(appearance.topInsets.top)
            make.left.equalTo(circle.snp.right).offset(appearance.topInsets.left)
            make.right.lessThanOrEqualTo(rightView.snp.left).offset(-appearance.topInsets.right).priority(appearance.rightEdgeConstraintPriority)
            make.bottom.equalTo(bottomView.snp.top).offset(-appearance.topInsets.bottom)
        }

        bottomView.snp.makeConstraints { make in
            make.size.greaterThanOrEqualTo(appearance.bottomLineSize)
            make.top.equalTo(topView.snp.bottom).offset(appearance.bottomInsets.top)
            make.left.equalTo(circle.snp.right).offset(appearance.bottomInsets.left)
            make.right.lessThanOrEqualToSuperview().offset(-appearance.bottomInsets.right).priority(appearance.rightEdgeConstraintPriority)
            make.bottom.equalToSuperview().offset(-appearance.bottomInsets.bottom)
        }

        rightView.snp.makeConstraints { make in
            make.width.equalTo(appearance.rightLineSize.width)
            make.top.right.equalToSuperview().inset(appearance.rightInsets)
            make.bottom.equalTo(bottomView.snp.top).offset(-appearance.rightInsets.bottom)
        }

    }
}
