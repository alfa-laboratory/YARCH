//
// SUT: CatalogViewModel
//

import Quick
import Nimble

@testable import YARCH

class CatalogViewModelTests: QuickSpec {

    override func spec() {
        describe("equalit operator") {
            it("should return true for same objects") {
                expect(TestData.viewModel == TestData.sameViewModel).to(beTrue())
            }

            it("should return false for objects with different uid") {
                expect(TestData.viewModel == TestData.differentViewModel).to(beFalse())
            }

            it("should ignore name attribute for equality") {
                expect(TestData.viewModel == TestData.differentViewModelWithSameId).to(beTrue())
            }
        }
    }
}

extension CatalogViewModelTests {
    enum TestData {
        static let viewModel = CatalogViewModel(uid: "1", title: "SomeCrypto1")
        static let sameViewModel = CatalogViewModel(uid: "1", title: "SomeCrypto1")
        static let differentViewModel = CatalogViewModel(uid: "2", title: "SomeCrypto2")
        static let differentViewModelWithSameId = CatalogViewModel(uid: "1", title: "SomeCrypto2")
    }
}
