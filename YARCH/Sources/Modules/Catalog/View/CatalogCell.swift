import Foundation
import UIKit

class CatalogCell: UITableViewCell {

    struct Appearance {
        let labelOffset: CGFloat = 12
        let separatorHeight: CGFloat = 1
        let separatorColor = UIColor(red: 11/255, green: 31/255, blue: 53/255, alpha: 0.05)
        let titleColor: UIColor = .black
    }

    lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = self.appearance.titleColor
        label.numberOfLines = 2
        return label
    }()

    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = self.appearance.separatorColor
        return view
    }()

    let appearance = Appearance()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: appearance.labelOffset).isActive = true
        title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: appearance.labelOffset).isActive = true
        title.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -appearance.labelOffset).isActive = true
        title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -appearance.labelOffset).isActive = true

        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: appearance.separatorHeight).isActive = true
        separator.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: appearance.labelOffset).isActive = true
    }
}
