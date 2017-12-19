//
//  SUT: CatalogModel
//

import Quick
import Nimble

@testable import YARCH

class CatalogModelTests: QuickSpec {
	override func spec() {
		describe("equality operator") {
			it("should return true for same objects") {
				expect(TestData.model == TestData.model).to(beTrue())
			}

			it("should return false for objects with different uid") {
				expect(TestData.model == TestData.differentUidModel).to(beFalse())
			}

			it("should ignore name attribute for equality") {
				expect(TestData.model == TestData.differentNameModel).to(beTrue())
			}
		}
	}
}

extension CatalogModelTests {
	enum TestData {

		static let uid = UUID().uuidString
		static let name = "Name"
        static let symbol = "S"
        static let coinName = "coinName"
        static let fullName = "fullName"
        static let algorithm = "alg"
		static let model = CatalogModel(uid: uid, name: name, symbol: symbol, coinName: coinName, fullName: fullName, algorithm: algorithm)
		static let differentUidModel = CatalogModel(uid: UUID().uuidString, name: name, symbol: symbol, coinName: coinName, fullName: fullName, algorithm: algorithm)

		static let differentNameModel = CatalogModel(uid: uid, name: "diffName", symbol: symbol, coinName: coinName, fullName: fullName, algorithm: algorithm)

		static let defaultEntitiesCollectionCount = 1
		static func entitiesCollection(withCount count: Int = defaultEntitiesCollectionCount) -> [CatalogModel] {
			var collection: [CatalogModel] = []
			while collection.count < count {
				collection.append(CatalogModel(uid: uid, name: name, symbol: symbol, coinName: coinName, fullName: fullName, algorithm: algorithm))
			}
			return collection
		}
	}
}
