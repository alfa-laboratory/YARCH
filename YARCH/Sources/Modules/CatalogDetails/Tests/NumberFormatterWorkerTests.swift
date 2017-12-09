//
// SUT: NumberFormatterWorker
//

import Quick
import Nimble

@testable import YARCH

class NumberFormatterWorkerTests: QuickSpec {

    override func spec() {
        var worker: NumberFormatterWorker!

        beforeEach {
            worker = NumberFormatterWorker()
        }

        describe(".getPercentIntegerPart") {
            it("should format fractional part") {
                expect(worker.getPercentIntegerPart(0.01)).to(equal("1 %"))
            }

            it("should format fractional part with 2-digit percents") {
                expect(worker.getPercentIntegerPart(0.84)).to(equal("84 %"))
            }
        }
    }

}
