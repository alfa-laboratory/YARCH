import Foundation

protocol Coordinator: class {
    var dependencies: [Coordinator] { get set }

    func start()
    func addDependency(_ coordinator: Coordinator)
    func removeDependency(_ coordinator: Coordinator?)
}

extension Coordinator {
    func addDependency(_ coordinator: Coordinator) {
        if !self.dependencies.contains(where: { $0 === coordinator }) {
            self.dependencies.append(coordinator)
        }
    }

    func removeDependency(_ coordinator: Coordinator?) {
        self.dependencies = self.dependencies.filter { $0 !== coordinator }
    }
}
