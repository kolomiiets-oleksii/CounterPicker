import Testing

@testable import CounterPicker

@MainActor
@Suite
struct CounterTests {
    @Test("Counter initializes with default digit counts")
    func counterDefaultInitialization() {
        let counter = Counter(reading: 0, wholeDigitsCount: nil, fractionDigitsCount: nil)
        #expect(counter.wholeDigits.count == 5)
        #expect(counter.fractionDigits.count == 1)
    }

    @Test("Counter initializes with custom digit counts")
    func counterCustomInitialization() {
        let counter = Counter(reading: 0, wholeDigitsCount: 7, fractionDigitsCount: 3)
        #expect(counter.wholeDigits.count == 7)
        #expect(counter.fractionDigits.count == 3)
    }

    // MARK: - Whole Digits Extraction

    @Test("Counter extracts whole digits with leading zeros padding")
    func counterWholeDigitsPadding() {
        let counter = Counter(reading: 123, wholeDigitsCount: 5, fractionDigitsCount: 1)
        #expect(counter.wholeDigits == [0, 0, 1, 2, 3])
    }

    @Test("Counter extracts whole digits when value exceeds configured digits")
    func counterWholeDigitsOverflow() {
        let counter = Counter(reading: 123456, wholeDigitsCount: 3, fractionDigitsCount: 1)
        // Takes last 3 digits
        #expect(counter.wholeDigits == [4, 5, 6])
    }

    @Test("Counter extracts zero whole digits correctly")
    func counterZeroWholeDigits() {
        let counter = Counter(reading: 0.5, wholeDigitsCount: 5, fractionDigitsCount: 1)
        #expect(counter.wholeDigits == [0, 0, 0, 0, 0])
    }

    @Test("Counter extracts whole digits from large numbers")
    func counterLargeWholeDigits() {
        let counter = Counter(reading: 99999.9, wholeDigitsCount: 5, fractionDigitsCount: 1)
        #expect(counter.wholeDigits == [9, 9, 9, 9, 9])
    }

    // MARK: - Fractional Digits Extraction

    @Test("Counter extracts fractional digits with padding")
    func counterFractionalDigitsPadding() {
        let counter = Counter(reading: 123.4, wholeDigitsCount: 5, fractionDigitsCount: 3)
        #expect(counter.fractionDigits == [4, 0, 0])
    }

    @Test("Counter extracts fractional digits without excess precision")
    func counterFractionalDigitsTruncation() {
        let counter = Counter(reading: 100.12345, wholeDigitsCount: 5, fractionDigitsCount: 2)
        #expect(counter.fractionDigits == [1, 2])
    }

    @Test("Counter handles zero fractional digits")
    func counterZeroFractionalDigits() {
        let counter = Counter(reading: 123.0, wholeDigitsCount: 5, fractionDigitsCount: 1)
        #expect(counter.fractionDigits == [0])
    }

    @Test("Counter handles multiple fractional digits")
    func counterMultipleFractionalDigits() {
        let counter = Counter(reading: 22222.222, wholeDigitsCount: 5, fractionDigitsCount: 3)
        #expect(counter.fractionDigits == [2, 2, 2])
    }

    // MARK: - Counter Value

    @Test("Counter returns current value from digits")
    func counterValueBasic() {
        let counter = Counter(reading: 123.4, wholeDigitsCount: 5, fractionDigitsCount: 1)
        let result = counter.value()
        #expect(result == 123.4)
    }

    @Test("Counter returns value with modified digits")
    func counterValueAfterModification() {
        let counter = Counter(reading: 0, wholeDigitsCount: 5, fractionDigitsCount: 1)
        counter.wholeDigits = [0, 0, 5, 0, 0]
        counter.fractionDigits = [5]
        let result = counter.value()
        #expect(result == 500.5)
    }

    @Test("Counter returns value with multiple fractional digits")
    func counterValueMultipleFractions() {
        let counter = Counter(reading: 0, wholeDigitsCount: 5, fractionDigitsCount: 3)
        counter.wholeDigits = [0, 1, 2, 3, 4]
        counter.fractionDigits = [5, 6, 7]
        let result = counter.value()
        #expect(result == 1234.567)
    }

    // MARK: - Update Reading

    @Test("Counter updates reading from new value")
    func counterUpdateReading() {
        let counter = Counter(reading: 0, wholeDigitsCount: 5, fractionDigitsCount: 1)
        counter.updateReading(555.5)
        #expect(counter.wholeDigits == [0, 0, 5, 5, 5])
        #expect(counter.fractionDigits == [5])
    }

    @Test("Counter updates reading with different precision")
    func counterUpdateReadingPrecision() {
        let counter = Counter(reading: 0, wholeDigitsCount: 5, fractionDigitsCount: 2)
        counter.updateReading(99.99)
        #expect(counter.wholeDigits == [0, 0, 0, 9, 9])
        #expect(counter.fractionDigits == [9, 9])
    }

    // MARK: - Edge Cases

    @Test("Counter handles negative numbers")
    func counterNegativeNumbers() {
        let counter = Counter(reading: -123.4, wholeDigitsCount: 5, fractionDigitsCount: 1)
        #expect(counter.wholeDigits == [0, 0, 1, 2, 3])
        #expect(counter.fractionDigits == [4])
    }

    @Test("Counter handles very small fractional values")
    func counterSmallFractions() {
        let counter = Counter(reading: 1.001, wholeDigitsCount: 5, fractionDigitsCount: 3)
        #expect(counter.fractionDigits == [0, 0, 1])
    }

    @Test("Counter roundtrip: read → modify → get value")
    func counterRoundtrip() {
        let counter = Counter(reading: 22222.222, wholeDigitsCount: 5, fractionDigitsCount: 3)
        counter.updateReading(11111.111)
        let result = counter.value()
        #expect(result == 11111.111)
    }
}
