enum AuthorizationStatus {
    case authorized
    case notAuthorized
}

protocol AppLaunchPresenterBusinessLogic {
    func checkAuthorization(status: (AuthorizationStatus) -> Void)
}

final class AppLaunchPresenter: AppLaunchPresenterBusinessLogic {

    private var logout = true

    func checkAuthorization(status: (AuthorizationStatus) -> Void) {
        if logout {
            status(.notAuthorized)
        } else {
            status(.authorized)
        }
        logout = !logout
    }
}
