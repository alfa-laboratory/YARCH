protocol AppLaunchFactory {
    func makeAppLaunchModule() -> AppLaunchPresenterBusinessLogic
}

protocol AuthModuleFactory {
    func makeAuthModule() -> AuthLoginView
}

class ModuleFactory: AppLaunchFactory, AuthModuleFactory {
    func makeAppLaunchModule() -> AppLaunchPresenterBusinessLogic {
        return AppLaunchPresenter()
    }

    func makeAuthModule() -> AuthLoginView {
        return AuthLoginController()
    }
}
