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
        var tableViewDataSourceMock: CatalogTableDataSourceMock!
        var tableViewDelegateMock: CatalogTableDelegateMock!

		beforeEach {
            tableViewDataSourceMock = CatalogTableDataSourceMock()
            tableViewDelegateMock = CatalogTableDelegateMock()
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

        describe(".display") {
            beforeEach {
                viewController.tableHandler = tableViewDelegateMock
                viewController.tableDataSource = tableViewDataSourceMock
            }
            it("should write viewModels to both handler and datasource simultaneoulsy") {
                // given
                tableViewDataSourceMock.representableViewModelsGetterStub = []
                tableViewDelegateMock.representableViewModelsGetterStub = []

                // when
                viewController.display(newState: TestData.resultState.state)

                // then
                expect(tableViewDataSourceMock.representableViewModelsSetterDidCalled).to(beGreaterThan(1))
                expect(tableViewDelegateMock.representableViewModelsSetterDidCalled).to(beGreaterThan(1))
            }
        }
	}
}

extension CatalogViewControllerTests {
	enum TestData {
        static let title = "Title"
		static let request = Catalog.ShowItems.Request()
        static let viewModels = [CatalogViewModel(uid: "1", title: "SomeCrypto1"), CatalogViewModel(uid: "2", title: "SomeCrypto2")]
        static let resultState = Catalog.ShowItems.ViewModel.init(state: .result(viewModels))
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

private class CatalogTableDataSourceMock: CatalogTableDataSource {

    var representableViewModelsGetterDidCalled: Int = 0
    var representableViewModelsSetterDidCalled: Int = 0
    var representableViewModelsGetterStub: [CatalogViewModel]?
    var representableViewModelsSetterValue: [CatalogViewModel]?

    override var representableViewModels: [CatalogViewModel] {
        get {
            representableViewModelsGetterDidCalled += 1
            return representableViewModelsGetterStub!
        }
        set {
            representableViewModelsSetterDidCalled += 1
            representableViewModelsSetterValue = newValue
        }
    }
}

private class CatalogTableDelegateMock: CatalogTableDelegate {

    var representableViewModelsGetterDidCalled: Int = 0
    var representableViewModelsSetterDidCalled: Int = 0
    var representableViewModelsGetterStub: [CatalogViewModel]?
    var representableViewModelsSetterValue: [CatalogViewModel]?

    override var representableViewModels: [CatalogViewModel] {
        get {
            representableViewModelsGetterDidCalled += 1
            return representableViewModelsGetterStub!
        }
        set {
            representableViewModelsSetterDidCalled += 1
            representableViewModelsSetterValue = newValue
        }
    }
}
