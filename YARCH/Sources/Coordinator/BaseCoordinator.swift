import Foundation

protocol Coordinator: class {
    func start()
    func addDependency(_ coordinator: Coordinator)
    func removeDependency(_ coordinator: Coordinator?)
}

class BaseCoordinator: Coordinator {
    var dependencies: [Coordinator] = []

    deinit {
        print("deinit: \(self)")
    }

    func start() { assert(false, "Should be overridden by subclass") }

    func addDependency(_ coordinator: Coordinator) {
        if dependencies.contains(where: { $0 === coordinator }) { return }
        dependencies.append(coordinator)
    }

    func removeDependency(_ coordinator: Coordinator?) {
        guard let indexToRemove = dependencies.index(where: { $0 === coordinator }) else { return }
        dependencies.remove(at: indexToRemove)
    }
}
