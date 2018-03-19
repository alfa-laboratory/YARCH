protocol AppLaunchFactory {
    func makeAppLaunchModule() -> AppLaunchPresenterBusinessLogic
}

protocol AuthModuleFactory {
    func makeAuthModule() -> AuthLoginViewProtocol
}

class ModuleFactory: AppLaunchFactory, AuthModuleFactory {
    func makeAppLaunchModule() -> AppLaunchPresenterBusinessLogic {
        return AppLaunchPresenter()
    }

    func makeAuthModule() -> AuthLoginViewProtocol {
        return AuthLoginController()
    }
}
