import UIKit

extension UIView {
    func setRadius(radius: CGFloat) {
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
