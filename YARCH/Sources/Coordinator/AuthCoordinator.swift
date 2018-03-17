protocol AuthCoordinatorOutput {
    var finishFlow: (() -> Void)? { get set }
}

final class AuthCoordinator: BaseCoordinator, AuthCoordinatorOutput {
    var finishFlow: (() -> Void)?
    private let router: Router
    private let moduleFactory: AuthModuleFactory

    init(router: Router, moduleFactory: AuthModuleFactory) {
        self.router = router
        self.moduleFactory = moduleFactory
    }

    override func start() {
        showLoginView()
    }

    // MARK: - Show current flow's controllers

    private func showLoginView() {
        var view = moduleFactory.makeAuthModule()
        view.onSignInButtonTap = { [weak self] in
            self?.finishFlow?()
        }
        router.setRootModule(view, hideBar: false)
    }
}
