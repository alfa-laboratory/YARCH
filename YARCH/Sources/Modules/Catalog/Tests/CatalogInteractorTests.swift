//
//  SUT: CatalogInteractor
//
//  Collaborators:
//  CatalogProvider
//  CatalogPresenter
//

import Quick
import Nimble

@testable import YARCH

class CatalogInteractorTests: QuickSpec {
	override func spec() {
		var interactor: CatalogInteractor!
		var presenterMock: CatalogPresenterMock!
		var providerMock: CatalogProviderMock!

		beforeEach {
			providerMock = CatalogProviderMock()
			presenterMock = CatalogPresenterMock()
			interactor = CatalogInteractor(presenter: presenterMock, provider: providerMock)
		}

		describe(".fetching items") {
			it("should get data from provider") {
				// when
				interactor.fetchItems(request: TestData.request)
				// then
				expect(providerMock.getItemsDidCalled).to(equal(1))
			}

			context("getItems successfull") {
				it("should prepare success response and call presenter") {
					// given
					providerMock.getItemsCompletionStub = TestData.models
					// when
					interactor.fetchItems(request: TestData.request)
					// then
					expect(presenterMock.presentItemsDidCalled).to(equal(1))
					expect(presenterMock.presentItemsArguments).toNot(beNil())
				}
			}

			context("getItems failed") {
				it("should prepare failed response and call presenter") {
					// given
					providerMock.getItemsCompletionStub = nil
					// when
					interactor.fetchItems(request: TestData.request)
					// then
					expect(presenterMock.presentItemsDidCalled).to(equal(1))
					expect(presenterMock.presentItemsArguments).toNot(beNil())
					expect { if case .failure(_)? = presenterMock.presentItemsArguments?.result { return true }; return false }.to(beTrue())
				}
			}
		}
	}
}

extension CatalogInteractorTests {
	enum TestData {
		static let request = Catalog.ShowItems.Request()
		static let models = CatalogModelTests.TestData.entitiesCollection()

		fileprivate static let underlyingError = ErrorMock()
	}
}

private class CatalogProviderMock: ProvidesCatalogItems {
	var getItemsDidCalled: Int = 0
	var getItemsArguments: (([CatalogModel]?) -> Void)?
	var getItemsCompletionStub: [CatalogModel]?

	func getItems(completion: @escaping ([CatalogModel]?) -> Void) {
		getItemsDidCalled += 1
		getItemsArguments = completion
		completion(getItemsCompletionStub)
	}
}

private class CatalogPresenterMock: CatalogPresentationLogic {
	var presentItemsDidCalled: Int = 0
	var presentItemsArguments: Catalog.ShowItems.Response?

	func presentItems(response: Catalog.ShowItems.Response) {
		presentItemsDidCalled += 1
		presentItemsArguments = response
	}
}

private class ErrorMock: Error { }
