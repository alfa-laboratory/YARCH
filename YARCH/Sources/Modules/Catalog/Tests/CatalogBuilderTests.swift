//
//  SUT: CatalogBuilder
//
//  Collaborators:
//  CatalogViewController
//  CatalogInteractor
//  CatalogPresenter
//  CatalogProvider
//

import Quick
import Nimble

@testable import YARCH

class CatalogBuilderTests: QuickSpec {
	override func spec() {
		var builder: CatalogBuilder!

		beforeEach {
			builder = CatalogBuilder().setTitle(TestData.title)
		}

		describe(".build") {
			it("should build module parts") {
				// when
				let controller = builder.build() as? CatalogViewController
				let interactor = controller?.interactor as? CatalogInteractor
				let presenter = interactor?.presenter as? CatalogPresenter

				// then
				expect(controller).toNot(beNil())
				expect(interactor).toNot(beNil())
				expect(presenter).toNot(beNil())
			}

			it("should set dependencies between module parts") {
				// when
				let controller = builder.build() as? CatalogViewController
				let interactor = controller?.interactor as? CatalogInteractor
				let presenter = interactor?.presenter as? CatalogPresenter

				// then
				expect(presenter?.viewController).to(beIdenticalTo(controller))
			}
		}
	}
}

extension CatalogBuilderTests {
	enum TestData {
		static let initialState = Catalog.ViewControllerState.loading
        static let title = "Title"
	}
}
