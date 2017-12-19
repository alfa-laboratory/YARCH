import Foundation

struct ResponseModel: Decodable {
    let response: String
    let message: String
    let baseImageUrl: String
    let baseLinkUrl: String
    let data: [String: CatalogModel]

    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case message = "Message"
        case baseImageUrl = "BaseImageUrl"
        case baseLinkUrl = "BaseLinkUrl"
        case data = "Data"
    }
}
