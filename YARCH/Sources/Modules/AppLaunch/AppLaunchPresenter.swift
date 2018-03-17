enum AuthorizationStatus {
    case Authorized
    case NotAuthorized
}

protocol AppLaunchPresenterBusinessLogic {
    func checkAuthorization(status: (AuthorizationStatus) -> Void)
}

final class AppLaunchPresenter: AppLaunchPresenterBusinessLogic {

    private var logout = true

    func checkAuthorization(status: (AuthorizationStatus) -> Void) {
        if logout {
            status(.NotAuthorized)
        } else {
            status(.Authorized)
        }
        logout = !logout
    }
}
