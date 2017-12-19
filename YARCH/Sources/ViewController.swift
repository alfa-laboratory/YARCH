import UIKit

class ViewController: UIViewController {

    @IBAction func catalogButtonDidTapped(_ sender: Any) {
        let controller = CatalogBuilder().setTitle("Catalog").build()
        navigationController?.pushViewController(controller, animated: true)
    }
}
