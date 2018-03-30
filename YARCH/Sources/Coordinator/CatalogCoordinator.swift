protocol CatalogCoordinatorOutput {
    var finishFlow: (() -> Void)? { get set }
}

final class CatalogCoordinator: Coordinator, CatalogCoordinatorOutput {
    var finishFlow: (() -> Void)?

    var dependencies: [Coordinator] = []
    private let router: Router

    init(router: Router) {
        self.router = router
    }

    func start() {
        showCatalogView()
    }

    // MARK: - Show current flow's controllers

    private func showCatalogView() {
        var view = CatalogBuilder().setTitle("Catalog").build()
        view.onCoinSelect = { [weak self] coinId in
            self?.showDetailView(coinId: coinId)
        }
        view.onSignUpButtonTap = { [weak self] in
            self?.finishFlow?()
        }
        router.setRootModule(view, hideBar: false)
    }

    private func showDetailView(coinId: UniqueIdentifier) {
        let view = CatalogDetailsBuilder().set(initialState: .initial(id: coinId)).build()
        router.push(view)
    }
}
