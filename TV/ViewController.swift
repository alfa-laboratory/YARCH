import UIKit

class ViewController: UIViewController {
    @IBAction func catalogButtonDidTapped(_ sender: Any) {
        let controller = CatalogBuilder().setTitle("Catalog").build()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

