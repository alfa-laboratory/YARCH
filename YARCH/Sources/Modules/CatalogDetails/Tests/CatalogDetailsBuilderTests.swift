//
//  SUT: CatalogDetailsBuilder
//
//  Collaborators:
//  CatalogDetailsViewController
//  CatalogDetailsInteractor
//  CatalogDetailsPresenter
//  CatalogDetailsProvider
//

import Quick
import Nimble

@testable import YARCH

class CatalogDetailsBuilderTests: QuickSpec {
	override func spec() {
		var builder: CatalogDetailsBuilder!

		beforeEach {
			builder = CatalogDetailsBuilder()
		}

		describe(".build") {
			it("should build module parts") {
				// when
				let controller = builder.set(initialState: TestData.initialState).build() as? CatalogDetailsViewController
				let interactor = controller?.interactor as? CatalogDetailsInteractor
				let presenter = interactor?.presenter as? CatalogDetailsPresenter

				// then
				expect(controller).toNot(beNil())
				expect(interactor).toNot(beNil())
				expect(presenter).toNot(beNil())
			}

			it("should set dependencies between module parts") {
				// when
				let controller = builder.set(initialState: TestData.initialState).build() as? CatalogDetailsViewController
				let interactor = controller?.interactor as? CatalogDetailsInteractor
				let presenter = interactor?.presenter as? CatalogDetailsPresenter

				// then
				expect(presenter?.viewController).to(beIdenticalTo(controller))
			}
		}
	}
}

extension CatalogDetailsBuilderTests {
	enum TestData {
		static let initialState = CatalogDetails.ViewControllerState.loading
	}
}
