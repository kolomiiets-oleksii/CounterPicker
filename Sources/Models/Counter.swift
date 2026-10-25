import Observation
import SwiftUI

@MainActor
@Observable
class Counter {
    private enum Constant {
        static let wholeCount: Int = 5
        static let fractionCount: Int = 1
    }

    var wholeDigits: [Int]
    var fractionDigits: [Int]

    private let maxWhole: Int
    private let maxFraction: Int

    init(
        reading: Double,
        wholeDigitsCount: Int?,
        fractionDigitsCount: Int?
    ) {
        let maxWhole = wholeDigitsCount ?? Constant.wholeCount
        let maxFraction = fractionDigitsCount ?? Constant.fractionCount
        self.maxWhole = maxWhole
        self.maxFraction = maxFraction
        self.wholeDigits = reading.digits(maxWhole)
        self.fractionDigits = reading.fractions(maxFraction)
    }

    func updateReading(_ newReading: Double) {
        self.wholeDigits = newReading.digits(maxWhole)
        self.fractionDigits = newReading.fractions(maxFraction)
    }

    func value() -> Double? {
        let integerString = wholeDigits.map { "\($0)" }.joined()
        let fractionString = fractionDigits.map { "\($0)" }.joined()
        let fullString = "\(integerString).\(fractionString)"

        return Double(fullString)
    }
}
