// Хидер таблицы CatalogDetails

import UIKit

extension CatalogDetailsHeaderView {
    struct Appearance {
        let imageHeight: CGFloat = 100
        let imageTopInset: CGFloat = 15
    }
}

class CatalogDetailsHeaderView: UIView {

    let appearance: Appearance

    lazy var imageView: CatalogDetailsCoinImageView = {
        let view = CatalogDetailsCoinImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = appearance.imageHeight / 2
        return view
    }()

    init(appearance: Appearance = Appearance()) {
        self.appearance = appearance
        super.init(frame: .zero)
        addSubviews()
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviews() {
        addSubview(imageView)
    }

    // MARK: Layout

    func makeConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(appearance.imageTopInset)
            make.centerX.equalTo(self)
            make.size.equalTo(appearance.imageHeight)
        }
    }
}
