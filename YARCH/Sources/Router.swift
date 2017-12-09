//
//  Copyright © 2018 Alfa-Bank. All rights reserved.
//

import UIKit

class Router {
    static let shared = Router()

    weak var navigationController: UINavigationController?

    func push(_ viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        navigationController?.present(viewController, animated: animated, completion: completion)
    }
}
