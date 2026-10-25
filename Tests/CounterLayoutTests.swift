import CoreGraphics
import Testing

@testable import CounterPicker

@Suite
struct CounterLayoutTests {
    @Test("Width at scale 1 is the columns, the wheel overlap and the separator")
    func widthAtDefaultScale() {
        // 6 digits * 42 + 18 + 8
        #expect(CounterLayout.width(digitCount: 6, scale: 1) == 278)
    }

    @Test("Width grows linearly with the scale")
    func widthScalesLinearly() {
        #expect(CounterLayout.width(digitCount: 6, scale: 2) == 556)
    }

    @Test("A wide container keeps the preferred scale")
    func wideContainerKeepsPreferred() {
        let scale = CounterLayout.scale(preferred: 1.5, digitCount: 6, availableWidth: 2000)
        #expect(scale == 1.5)
    }

    @Test("A narrow container shrinks the scale until the counter fits")
    func narrowContainerShrinks() {
        let scale = CounterLayout.scale(preferred: 1, digitCount: 6, availableWidth: 200)
        #expect(scale < 1)
        #expect(CounterLayout.width(digitCount: 6, scale: scale) <= 200 + 0.0001)
    }

    @Test("The counter never exceeds the container at any text size or digit count", arguments: [1, 3, 6, 10, 13])
    func neverExceedsContainer(digitCount: Int) {
        for preferred in [0.8, 1, 1.3, 2, 3.1] as [CGFloat] {
            for available in [120, 200, 320, 393, 430, 834] as [CGFloat] {
                let scale = CounterLayout.scale(preferred: preferred, digitCount: digitCount, availableWidth: available)
                #expect(scale <= preferred)
                #expect(CounterLayout.width(digitCount: digitCount, scale: scale) <= available + 0.0001)
            }
        }
    }

    @Test("A missing or empty container width means no limit", arguments: [nil, 0, -10] as [CGFloat?])
    func noLimit(availableWidth: CGFloat?) {
        let scale = CounterLayout.scale(preferred: 2, digitCount: 6, availableWidth: availableWidth)
        #expect(scale == 2)
    }
}
