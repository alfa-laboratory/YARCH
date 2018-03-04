// ImageView, которая может находиться в режиме плейсхолдера

import UIKit

class CatalogDetailsCoinImageView: UIImageView {

    override var image: UIImage? {
        didSet {
            if image != nil {
                hidePlaceholder()
            }
        }
    }

    func showPlaceholder() {
        backgroundColor = UIColor.gray
    }

    func hidePlaceholder() {
        backgroundColor = UIColor.clear
    }

}
