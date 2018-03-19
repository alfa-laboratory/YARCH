import UIKit

protocol AuthLoginViewOutput: class {
    func signInButtonDidTap()
}

class AuthLoginView: UIView {
    lazy var signInButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setRadius(radius: 5.0)
        button.setTitle("Sign in", for: .normal)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(signInButtonDidTap), for: .touchUpInside)
        return button
    }()

    weak var output: AuthLoginViewOutput?

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviews() {
        addSubview(signInButton)
    }

    func makeConstraints() {
        signInButton.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.equalTo(200)
            make.height.equalTo(45)
        }
    }

    @objc
    func signInButtonDidTap() {
        output?.signInButtonDidTap()
    }
}
