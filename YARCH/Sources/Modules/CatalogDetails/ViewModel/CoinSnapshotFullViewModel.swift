// Вьюмодель изображения детальной информации о криптовалюте

import UIKit

struct CoinSnapshotFullViewModel: UniqueIdentifiable {
    let uid: UniqueIdentifier
    let title: String
    let image: UIImage?
    let properties: [CoinSnapshotPropertyViewModel]
}

extension CoinSnapshotFullViewModel: Equatable {
    static func == (lhs: CoinSnapshotFullViewModel, rhs: CoinSnapshotFullViewModel) -> Bool {
        return lhs.uid == rhs.uid &&
        lhs.title == rhs.title &&
        lhs.image == rhs.image &&
        lhs.properties == rhs.properties
    }
}
