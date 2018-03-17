import UIKit

final class AuthLoginController: UIViewController, AuthLoginView {

    var onSignInButtonTap: (() -> Void)?
    private var signInButton: UIButton = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Actions

    @objc func signInButtonDidTap() {
        onSignInButtonTap?()
    }

    // MARK: - Setup

    func setupUI() {

        title = "Authorization"
        view.backgroundColor = UIColor.white

        makeLoginButton()
    }

    func makeLoginButton() {

        view.addSubview(signInButton)
        signInButton.setRadius(radius: 5.0)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.setTitle("Sign in", for: .normal)
        signInButton.backgroundColor = UIColor.black
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        signInButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        signInButton.addTarget(self, action: #selector(signInButtonDidTap), for: .touchUpInside)
    }
}
