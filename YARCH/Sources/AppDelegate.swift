import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var sharedCache = URLCache.shared

    private var coordinator: Coordinator!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let urlCache = URLCache(memoryCapacity: 6 * 1024 * 1024, diskCapacity: 0, diskPath: nil)
        sharedCache = urlCache

        let navigation = UINavigationController()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()

        makeCoordinator(with: navigation)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        sharedCache.removeAllCachedResponses()
        sharedCache.diskCapacity = 0
        sharedCache.memoryCapacity = 0
    }

    // MARK: - Setters & Getters

    private func makeCoordinator(with root: UINavigationController) {
        let router = Router(rootController: root)
        let coordinatorFactory = CoordinatorFactory()
        let moduleFactory = ModuleFactory()
        coordinator = AppCoordinator(router: router, coordinatorFactory: coordinatorFactory, moduleFactory: moduleFactory)
        coordinator.start()
    }
}
