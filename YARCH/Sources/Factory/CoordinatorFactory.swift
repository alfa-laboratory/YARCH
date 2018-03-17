protocol CoordinatorFactoryBusinessLogic {
    func makeAuthCoordinator(router: Router) -> Coordinator & AuthCoordinatorOutput
    func makeCatalogCoordinator(router: Router) -> Coordinator & CatalogCoordinatorOutput
}

struct CoordinatorFactory: CoordinatorFactoryBusinessLogic {
    func makeAuthCoordinator(router: Router) -> Coordinator & AuthCoordinatorOutput {
        let moduleFactory = ModuleFactory()
        return AuthCoordinator(router: router, moduleFactory: moduleFactory)
    }

    func makeCatalogCoordinator(router: Router) -> Coordinator & CatalogCoordinatorOutput {
        return CatalogCoordinator(router: router)
    }
}
