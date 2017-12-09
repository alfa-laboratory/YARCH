// Модель данных свойства криптовалюты

import Foundation

enum CoinSnapshotPropertyType: String {
    case website = "Website"
    case twitter = "Twitter"
    case percentMined = "Percent Mined"
    case blockReward = "Block Reward"
}

struct CoinSnapshotPropertyViewModel: CatalogDetailsCellRepresentable {

    let type: CoinSnapshotPropertyType
    let value: String

    var title: String {
        return type.rawValue
    }

    var subtitle: String {
        return value
    }

    init?(type: CoinSnapshotPropertyType, value: String?) {
        guard let value = value else { return nil }
        self.type = type
        self.value = value
    }
}

extension CoinSnapshotPropertyViewModel: Equatable {
    static func == (lhs: CoinSnapshotPropertyViewModel, rhs: CoinSnapshotPropertyViewModel) -> Bool {
        return lhs.type == rhs.type &&
        lhs.value == rhs.value
    }
}
