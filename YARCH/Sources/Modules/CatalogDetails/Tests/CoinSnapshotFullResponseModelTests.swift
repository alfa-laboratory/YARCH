//
// SUT: CoinSnapshotFullResponseModel
//

import Quick
import Nimble

@testable import YARCH

class CoinSnapshotFullResponseModelTests: QuickSpec {
    override func spec() {
        describe("equalit operator") {
            it("should return true for same objects") {
                expect(TestData.model == TestData.model).to(beTrue())
            }

            it("should return false for objects with different uid") {
                expect(TestData.model == TestData.differentUidModel).to(beFalse())
            }

            it("should ignore name attribute for equality") {
                expect(TestData.model == TestData.differentTitleModel).to(beTrue())
            }
        }
    }
}

extension CoinSnapshotFullResponseModelTests {
    enum TestData {
        static let uid = UUID().uuidString
        static let title = "SomeCoin"
        static let otherTitle = "OtherCoin"
        static let imageUrlString = "http://www.example.com/image.png"
        static let website = "http://www.example.com"
        static let twitter = "http://www.twitter.com/jack"
        static let totalSupply = "10000000"
        static let totalMined = 8000000.0
        static let blockReward = 12.0

        static let model = CoinSnapshotFullModel(uid: uid,
                                                 title: title,
                                                 imageUrlString: imageUrlString,
                                                 website: website, twitter: twitter,
                                                 totalSupply: totalSupply,
                                                 totalMined: totalMined,
                                                 blockReward: blockReward)
        static let differentUidModel = CoinSnapshotFullModel(uid: UUID().uuidString,
                                                             title: title,
                                                             imageUrlString: imageUrlString,
                                                             website: website,
                                                             twitter: twitter,
                                                             totalSupply: totalSupply,
                                                             totalMined: totalMined,
                                                             blockReward: blockReward)
        static let differentTitleModel = CoinSnapshotFullModel(uid: uid,
                                                               title: otherTitle,
                                                               imageUrlString: imageUrlString,
                                                               website: website,
                                                               twitter: twitter,
                                                               totalSupply: totalSupply,
                                                               totalMined: totalMined,
                                                               blockReward: blockReward)
        static let constantUidModel = CoinSnapshotFullModel(uid: "1",
                                                            title: title,
                                                            imageUrlString: imageUrlString,
                                                            website: website,
                                                            twitter: twitter,
                                                            totalSupply: totalSupply,
                                                            totalMined: totalMined,
                                                            blockReward: blockReward)

        static let defaultEntitiesCollectionCount = 1
        static func entitiesCollection(withCount count: Int = defaultEntitiesCollectionCount) -> [CoinSnapshotFullModel] {
            var collection: [CoinSnapshotFullModel] = []
            while collection.count < count {
                collection.append(CoinSnapshotFullModel(uid: UUID().uuidString, title: title, imageUrlString: imageUrlString, website: website, twitter: twitter, totalSupply: totalSupply, totalMined: totalMined, blockReward: blockReward))
            }
            return collection
        }
    }
}
