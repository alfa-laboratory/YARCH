// Модель данных ответа от API

import Foundation

struct CoinSnapshotFullModel: Decodable, UniqueIdentifiable {
    let uid: String
    let title: String
    let imageUrlString: String
    let website: String
    let twitter: String
    let totalSupply: String
    let totalMined: Double
    let blockReward: Double

    private enum CodingKeys: String, CodingKey {
        case uid = "Id"
        case title = "H1Text"
        case imageUrlString = "ImageUrl"
        case website = "Website"
        case twitter = "Twitter"
        case totalSupply = "TotalCoinSupply"
        case totalMined = "TotalCoinsMined"
        case blockReward = "BlockReward"
    }
}

extension CoinSnapshotFullModel: Equatable {
    static func == (lhs: CoinSnapshotFullModel, rhs: CoinSnapshotFullModel) -> Bool {
        return lhs.uid == rhs.uid
    }
}

struct CoinSnapshotFullResponseWrapper {

    let model: CoinSnapshotFullModel

    enum RootKeys: String, CodingKey {
        case data = "Data"
    }
    enum DataKeys: String, CodingKey {
        case general = "General"
    }
}

extension CoinSnapshotFullResponseWrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let generalData = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        model = try generalData.decode(CoinSnapshotFullModel.self, forKey: .general)
    }
}
