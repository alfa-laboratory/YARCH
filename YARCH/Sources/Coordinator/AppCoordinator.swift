import UIKit

final class AppCoordinator: BaseCoordinator {
    private let presenter: AppLaunchPresenterBusinessLogic
    private let router: Router
    private let coordinatorFactory: CoordinatorFactory

    init(router: Router, coordinatorFactory: CoordinatorFactory, moduleFactory: AppLaunchFactory) {
        self.presenter = moduleFactory.makeAppLaunchModule()
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }

    override func start() {
        launchAppModule()
    }

    // MARK: - Show current flow's controllers

    private func launchAppModule() {
        self.presenter.checkAuthorization { [weak self] authorization in
            switch authorization {
            case .Authorized: self?.runCatalogFlow()
            case .NotAuthorized: self?.runAuthFlow()
            }
        }
    }

    // MARK: - Run coordinators and switch to another flow

    private func runAuthFlow() {
        var coordinator = coordinatorFactory.makeAuthCoordinator(router: router)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.start()
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start()
    }

    private func runCatalogFlow() {
        var coordinator = coordinatorFactory.makeCatalogCoordinator(router: router)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.start()
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start()
    }
}
