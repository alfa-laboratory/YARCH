import UIKit

class CatalogDetailsCell: UITableViewCell {

    struct Appearance {
        let separatorOffset: CGFloat = 12
        let separatorHeight: CGFloat = 1
        let separatorColor = UIColor(red: 11/255, green: 31/255, blue: 53/255, alpha: 0.05)
    }

    let appearance = Appearance()

    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = self.appearance.separatorColor
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupViews()
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(cellRepresentable: CatalogDetailsCellRepresentable) {
        textLabel?.text = cellRepresentable.title
        detailTextLabel?.text = cellRepresentable.subtitle
    }

    func setupViews() {
        contentView.addSubview(separator)
    }

    // MARK: Layout

    func makeConstraints() {
        separator.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.height.equalTo(appearance.separatorHeight)
            make.left.equalToSuperview().offset(appearance.separatorOffset)
        }
    }

}
