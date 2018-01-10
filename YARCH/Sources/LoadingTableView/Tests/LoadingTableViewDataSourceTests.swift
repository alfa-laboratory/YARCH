import Quick
import Nimble

@testable import YARCH

class LoadingTableViewDataSourceTests: QuickSpec {
    override func spec() {
        var dataSource: LoadingTableViewDataSource!
        var tableView: UITableViewMock!

        beforeEach {
            tableView = UITableViewMock()
            dataSource = LoadingTableViewDataSource(configuration: TestData.configuration)
        }

        describe(".numberOfSections") {
            it("should return number of sections") {
                //when
                let numberOfSections = dataSource.numberOfSections(in: tableView)
                //then
                expect(numberOfSections).to(equal(TestData.configuration.numberOfSection))
            }
        }

        describe(".numberOfRowsInSection") {
            it("should return number of rows in section") {
                //when
                let numberOfRowsInSection = dataSource.tableView(tableView, numberOfRowsInSection: 0)
                //then
                expect(numberOfRowsInSection).to(equal(TestData.configuration.numberOfRowsInSection))
            }
        }

        describe(".cellForRowAtIndexPath") {
            it("should register cell class") {
                // given
                let expectedCellType = LoadingTableViewCell.self
                let expectedCellIdentifier = String(describing: LoadingTableViewCell.self)

                // when
                _ = dataSource.tableView(tableView, cellForRowAt: TestData.indexPath)

                // then
                expect(tableView.registerCellDidCalled).to(equal(1))
                expect(tableView.registerCellIdentifierArguments.cellClass == expectedCellType).to(beTrue())
                expect(tableView.dequeueReusableCellArguments.identifier).to(equal(expectedCellIdentifier))
            }

            it("should get dequeued cell from table view") {
                // given
                let indexPath = TestData.indexPath
                let expectedCellIdentifier = String(describing: LoadingTableViewCell.self)

                // when
                _ = dataSource.tableView(tableView, cellForRowAt: indexPath)

                // then
                expect(tableView.dequeueReusableCellDidCalled).to(equal(1))
                expect(tableView.dequeueReusableCellArguments.identifier).to(equal(expectedCellIdentifier))
                expect(tableView.dequeueReusableCellArguments.indexPath).to(equal(indexPath))
            }
        }
    }
}

extension LoadingTableViewDataSourceTests {
    enum TestData {
        static let configuration = LoadingTableViewDataSource.Configuration(numberOfSection: 1, numberOfRowsInSection: 10)
        static let indexPath = IndexPath(row: 0, section: 0)
    }
}

class UITableViewMock: UITableView {
    var registerCellDidCalled = 0
    var registerCellIdentifierArguments: (cellClass: AnyClass?, identifier: String?) = (nil, nil)

    var dequeueReusableCellDidCalled = 0
    var dequeueReusableCellArguments: (identifier: String?, indexPath: IndexPath?) = (nil, nil)
    var dequeueReusableCellStub: UITableViewCell?

    var registerHeaderFooterDidCalled = 0
    var registerHeaderFooterArguments: (viewClass: AnyClass?, identifier: String?) = (nil, nil)

    var dequeueReusableHeaderFooterDidCalled = 0
    var dequeueReusableHeaderFooterArguments: String?
    var dequeueReusableHeaderFooterStub: UITableViewHeaderFooterView?

    init() {
        super.init(frame: .zero, style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        registerCellDidCalled += 1
        registerCellIdentifierArguments = (cellClass, identifier)
    }

    override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        dequeueReusableCellDidCalled += 1
        dequeueReusableCellArguments = (identifier, indexPath)
        return dequeueReusableCellStub ?? UITableViewCell()
    }

    override func register(_ aClass: AnyClass?, forHeaderFooterViewReuseIdentifier identifier: String) {
        registerHeaderFooterDidCalled += 1
        registerHeaderFooterArguments = (aClass, identifier)
    }

    override func dequeueReusableHeaderFooterView(withIdentifier identifier: String) -> UITableViewHeaderFooterView? {
        dequeueReusableHeaderFooterDidCalled += 1
        dequeueReusableHeaderFooterArguments = identifier
        return dequeueReusableHeaderFooterStub
    }

}
