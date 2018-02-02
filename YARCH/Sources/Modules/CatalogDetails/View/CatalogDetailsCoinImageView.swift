// ImageView, которая может находиться в режиме плейсхолдера

import UIKit

class CatalogDetailsCoinImageView: UIImageView {

    override var image: UIImage? {
        didSet {
            if image != nil {
                removePlaceholder()
            }
        }
    }

    func becomePlaceholder() {
        backgroundColor = UIColor.gray
    }

    func removePlaceholder() {
        backgroundColor = UIColor.clear
    }

}
