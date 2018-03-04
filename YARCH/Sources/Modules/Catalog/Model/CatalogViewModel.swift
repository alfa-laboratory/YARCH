import Foundation

struct CatalogViewModel {
    let uid: UniqueIdentifier
    let title: String
}

extension CatalogViewModel: Equatable {
    static func == (lhs: CatalogViewModel, rhs: CatalogViewModel) -> Bool {
        return lhs.uid == rhs.uid
    }
}
