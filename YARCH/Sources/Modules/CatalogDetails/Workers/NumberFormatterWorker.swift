// Вокрер форматирования процентов

import Foundation

class NumberFormatterWorker {

    lazy var percentIntegerPartFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.secondaryGroupingSize = 0
        return formatter
    }()

    func getPercentIntegerPart(_ doubleValue: Double) -> String {
        let percent = doubleValue * 100
        let number = NSNumber(value: percent)
        let percentString = String(describing: percentIntegerPartFormatter.string(from: number) ?? "")
        return "\(percentString) %"
    }
}
