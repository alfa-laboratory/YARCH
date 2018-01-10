import Quick
import Nimble

@testable import YARCH

class LoadingTableViewDelegateTests: QuickSpec {
    override func spec() {
        var delegate: LoadingTableViewDelegate!
        var tableView: UITableViewMock!

        beforeEach {
            tableView = UITableViewMock()
            delegate = LoadingTableViewDelegate()
        }

        describe(".viewForHeaderInSection") {
            it("should register view class") {
                // given
                let expectedViewClass = LoadingSectionHeaderView.self
                let expectedHeaderIdentifier = String(describing: LoadingSectionHeaderView.self)

                // when
                _ = delegate.tableView(tableView, viewForHeaderInSection: 0)

                //then
                expect(tableView.registerHeaderFooterDidCalled).to(equal(1))
                expect(tableView.registerHeaderFooterArguments.viewClass == expectedViewClass).to(beTrue())
                expect(tableView.registerHeaderFooterArguments.identifier).to(equal(expectedHeaderIdentifier))
            }

            it("should get dequeued header view from table view") {
                //given
                let expectedHeaderIdentifier = String(describing: LoadingSectionHeaderView.self)

                //when
                _ = delegate.tableView(tableView, viewForHeaderInSection: 0)

                //then
                expect(tableView.dequeueReusableHeaderFooterDidCalled).to(equal(1))
                expect(tableView.dequeueReusableHeaderFooterArguments).to(equal(expectedHeaderIdentifier))
            }
        }

        describe(".heightForHeaderInSection") {
            it("should return height of section header") {
                //when
                let heightOfSections = delegate.tableView(tableView, heightForHeaderInSection: 0)

                //then
                expect(heightOfSections).to(equal(TestData.appearance.heightForSectionHeader))
            }

            it("automatic dimension of height for row") {
                //given
                let indexPath = TestData.indexPath
                let expectedHeightForRow = UITableViewAutomaticDimension
                //when
                let heightForRow = delegate.tableView(tableView, heightForRowAt: indexPath)
                //then
                expect(heightForRow).to(equal(expectedHeightForRow))
            }
        }
    }
}

extension LoadingTableViewDelegateTests {
    enum TestData {
        static let indexPath = IndexPath(row: 0, section: 0)
        static let appearance = LoadingTableViewDelegate.Appearance(heightForSectionHeader: 40)
    }
}
