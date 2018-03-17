protocol AuthLoginView: Presentable {
    var onSignInButtonTap: (() -> Void)? { get set }
}
