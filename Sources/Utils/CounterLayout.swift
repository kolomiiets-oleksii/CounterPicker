import CoreGraphics

/// Sizes of the counter at the default text size, and the rule that scales them.
///
/// Every length is a point value at scale 1. The whole view, digits and separator included,
/// is multiplied by one scale, so proportions never change.
enum CounterLayout {
    /// Width of a single wheel.
    static let wheelWidth: CGFloat = 60
    /// How far neighbouring wheels overlap, so the highlighted rows join into one band.
    static let wheelOverlap: CGFloat = 18
    static let wheelHeight: CGFloat = 84
    static let separatorWidth: CGFloat = 8
    static let digitFontSize: CGFloat = 20

    /// Width of the whole view for `digitCount` wheels plus the separator.
    ///
    /// The outer wheels reach `wheelOverlap / 2` past the layout width of a column, so that
    /// reach is part of the total and the view never draws outside its own bounds.
    static func width(digitCount: Int, scale: CGFloat) -> CGFloat {
        let columns = CGFloat(max(digitCount, 0)) * (wheelWidth - wheelOverlap)
        return (columns + wheelOverlap + separatorWidth) * scale
    }

    /// The scale to use: what Dynamic Type asks for, reduced until the view fits `availableWidth`.
    ///
    /// The scale is never raised above `preferred`, so a wide container does not stretch the
    /// counter. A missing, zero or negative `availableWidth` means no limit.
    static func scale(preferred: CGFloat, digitCount: Int, availableWidth: CGFloat?) -> CGFloat {
        guard let availableWidth, availableWidth > 0 else { return preferred }
        let fitting = availableWidth / width(digitCount: digitCount, scale: 1)
        return min(preferred, fitting)
    }
}
