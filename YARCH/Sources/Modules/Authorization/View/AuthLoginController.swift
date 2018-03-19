import UIKit

protocol AuthLoginViewProtocol: Presentable {
    var onSignInButtonTap: (() -> Void)? { get set }
}

final class AuthLoginController: UIViewController, AuthLoginViewProtocol {
    var onSignInButtonTap: (() -> Void)?
    private var signInButton: UIButton = UIButton(type: .custom)

    override func loadView() {
        let view = AuthLoginView(frame: UIScreen.main.bounds)
        view.output = self
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup

    func setupUI() {
        title = "Authorization"
        view.backgroundColor = UIColor.white
    }
}

extension AuthLoginController: AuthLoginViewOutput {
    func signInButtonDidTap() {
        onSignInButtonTap?()
    }
}
