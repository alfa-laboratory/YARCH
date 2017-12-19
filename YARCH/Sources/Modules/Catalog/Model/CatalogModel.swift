/// Модель данных, описывающая криптовалюту
struct CatalogModel: UniqueIdentifiable, Decodable {
	let uid: UniqueIdentifier
	let name: String
    let symbol: String
    let coinName: String
    let fullName: String
    let algorithm: String

    enum CodingKeys: String, CodingKey {
        case uid = "Id"
        case name = "Name"
        case symbol = "Symbol"
        case coinName = "CoinName"
        case fullName = "FullName"
        case algorithm = "Algorithm"
    }
}

extension CatalogModel: Equatable {
    static func == (lhs: CatalogModel, rhs: CatalogModel) -> Bool {
        return lhs.uid == rhs.uid
    }
}
