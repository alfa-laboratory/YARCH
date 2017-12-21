import UIKit

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

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        makeConstraints()
        selectionStyle = .none
    }

    func configureView(radius: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = self.appearance.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
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
        circle.widthAnchor.constraint(equalTo: circle.heightAnchor).isActive = true
        circle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: appearance.circleInsets.top).isActive = true
        circle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: appearance.circleInsets.left).isActive = true
        circle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -appearance.circleInsets.bottom).isActive = true

        topView.widthAnchor.constraint(greaterThanOrEqualToConstant: appearance.topLineSize.width).isActive = true
        topView.heightAnchor.constraint(greaterThanOrEqualToConstant: appearance.topLineSize.height).isActive = true
        topView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: appearance.topInsets.top).isActive = true
        topView.leftAnchor.constraint(equalTo: circle.rightAnchor, constant: appearance.topInsets.left).isActive = true
        let topViewRight = topView.rightAnchor.constraint(lessThanOrEqualTo: rightView.leftAnchor, constant: -appearance.topInsets.right)
        topViewRight.priority = .init(rawValue: Float(appearance.rightEdgeConstraintPriority))
        topViewRight.isActive = true
        topView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -appearance.topInsets.bottom).isActive = true

        bottomView.widthAnchor.constraint(greaterThanOrEqualToConstant: appearance.bottomLineSize.width).isActive = true
        bottomView.heightAnchor.constraint(greaterThanOrEqualToConstant: appearance.bottomLineSize.height).isActive = true
        bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: appearance.bottomInsets.top).isActive = true
        bottomView.leftAnchor.constraint(equalTo: circle.rightAnchor, constant: appearance.bottomInsets.left).isActive = true
        let bottomViewRight = bottomView.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -appearance.bottomInsets.right)
        bottomViewRight.priority = .init(rawValue: Float(appearance.rightEdgeConstraintPriority))
        bottomViewRight.isActive = true
        bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -appearance.bottomInsets.bottom).isActive = true

        rightView.widthAnchor.constraint(equalToConstant: appearance.rightLineSize.width).isActive = true
        rightView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: appearance.rightInsets.top).isActive = true
        rightView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -appearance.rightInsets.right).isActive = true
        rightView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -appearance.rightInsets.bottom).isActive = true
    }
}
