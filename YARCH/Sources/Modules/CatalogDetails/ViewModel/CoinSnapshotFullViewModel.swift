// Вьюмодель изображения детальной информации о криптовалюте

import UIKit

struct CoinSnapshotFullViewModel {
    let id: CoinId
    let title: String
    let image: UIImage?
    let properties: [CoinSnapshotPropertyViewModel]
}

extension CoinSnapshotFullViewModel: Equatable {
    static func == (lhs: CoinSnapshotFullViewModel, rhs: CoinSnapshotFullViewModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.image == rhs.image &&
        lhs.properties == rhs.properties
    }
}
