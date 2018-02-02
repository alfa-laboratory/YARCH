//
//  Вью-плейсхолдер
//

import UIKit

class CoinSymbolPlaceholderView: UIView {

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.addEllipse(in: rect)
        context.setFillColor(gray: 0.3, alpha: 0.4)
        context.fillPath()
    }

}
