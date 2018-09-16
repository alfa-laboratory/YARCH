import Foundation
import UIKit
import SnapKit

class CatalogCell: UITableViewCell {

    struct Appearance {
        let labelOffset: CGFloat = 12
        let separatorHeight: CGFloat = 1
        let separatorColor = UIColor(red: 11/255, green: 31/255, blue: 53/255, alpha: 0.05)
        let titleColor: UIColor = .black
    }

    lazy var title: UILabel = {
        let typeLabel = UILabel()
        typeLabel.textColor = self.appearance.titleColor
        typeLabel.numberOfLines = 2
        return typeLabel
    }()

    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = self.appearance.separatorColor
        return view
    }()

    let appearance = Appearance()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(cellRepresentable: CatalogViewModel) {
        title.text = cellRepresentable.title
    }

    func setupViews() {
        contentView.addSubview(title)
        contentView.addSubview(separator)
    }

    func setupConstraints() {
        title.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(appearance.labelOffset)
        }

        separator.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.height.equalTo(appearance.separatorHeight)
            make.left.equalToSuperview().offset(appearance.labelOffset)
        }
    }
}
