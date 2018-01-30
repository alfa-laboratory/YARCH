import UIKit

class ViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        Router.shared.navigationController = navigationController
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Router.shared.navigationController = navigationController
    }

    @IBAction func catalogButtonDidTapped(_ sender: Any) {
        let controller = CatalogBuilder().setTitle("Catalog").build()
        navigationController?.pushViewController(controller, animated: true)
    }
}
