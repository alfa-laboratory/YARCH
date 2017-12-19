//
//  SUT: CatalogViewController
//
//  Collaborators:
//  CatalogInteractor
//

import Quick
import Nimble

@testable import YARCH

class CatalogViewControllerTests: QuickSpec {
	override func spec() {
		var viewController: CatalogViewController!
		var interactorMock: CatalogInteractorMock!

		beforeEach {
			interactorMock = CatalogInteractorMock()
            viewController = CatalogViewController(title: TestData.title, interactor: interactorMock, loadingDataSource: LoadingTableViewDataSource(), loadingTableDelegate: LoadingTableViewDelegate())
		}

		describe(".fetching") {
			it("should call method in interactor") {
				// when
				viewController.fetchItems()

				// then
				expect(interactorMock.fetchItemsDidCalled).to(equal(1))
				expect(interactorMock.fetchItemsArguments).toNot(beNil())
			}
		}
	}
}

extension CatalogViewControllerTests {
	enum TestData {
        static let title = "Title"
		static let request = Catalog.ShowItems.Request()
	}
}

private class CatalogInteractorMock: CatalogBusinessLogic {
	var fetchItemsDidCalled: Int = 0
	var fetchItemsArguments: Catalog.ShowItems.Request?

	func fetchItems(request: Catalog.ShowItems.Request) {
		fetchItemsDidCalled += 1
		fetchItemsArguments = request
	}
}
