//
//  SUT: CatalogPresenter
//
//  Collaborators:
//  CatalogViewController
//

import Quick
import Nimble

@testable import YARCH

class CatalogPresenterTests: QuickSpec {
	override func spec() {
		var presenter: CatalogPresenter!
		var viewControllerMock: CatalogViewControllerMock!

		beforeEach {
			presenter = CatalogPresenter()
			viewControllerMock = CatalogViewControllerMock()
			presenter.viewController = viewControllerMock
		}

		describe(".presentItems") {
			context("successfull empty result") {
				it ("should prepare empty view model and display it in view") {
					// when
					presenter.presentItems(response: TestData.successEmptyResponse)
					// then
					expect(viewControllerMock.displayItemsDidCalled).to(beTruthy())
					expect { if case .emptyResult? = viewControllerMock.displayItemsArguments?.state { return true }; return false }.to(beTrue())
				}
			}

			context("successfull result") {
				it ("should prepare result view model and display it in view") {
					// when
					presenter.presentItems(response: TestData.successResponse)
					// then
					expect(viewControllerMock.displayItemsDidCalled).to(beTruthy())
					expect { if case .result(_)? = viewControllerMock.displayItemsArguments?.state { return true }; return false }.to(beTrue())
				}
			}

			context("failure result") {
				it ("should prepare error view model and display it in view") {
					// when
					presenter.presentItems(response: TestData.failureResponse)
					// then
					expect(viewControllerMock.displayItemsDidCalled).to(beTruthy())
					expect { if case .error? = viewControllerMock.displayItemsArguments?.state { return true }; return false }.to(beTrue())
				}
			}
		}
	}
}

extension CatalogPresenterTests {
	enum TestData {
		static let successEmptyResponse = Catalog.ShowItems.Response(result: .success([]))
        static let successModel = CatalogModel(uid: UUID().uuidString, name: "name", symbol: "S", coinName: "coinName", fullName: "fullName", algorithm: "alg")
		static let successResponse = Catalog.ShowItems.Response(result: .success([successModel]))
		static let failureResponse = Catalog.ShowItems.Response(result: .failure(Catalog.ShowItems.Response.Error.fetchError))
	}
}

private class CatalogViewControllerMock: CatalogDisplayLogic {
	var displayItemsDidCalled: Int = 0
	var displayItemsArguments: Catalog.ShowItems.ViewModel?

	func displayItems(viewModel: Catalog.ShowItems.ViewModel) {
		displayItemsDidCalled += 1
		displayItemsArguments = viewModel
	}
}
