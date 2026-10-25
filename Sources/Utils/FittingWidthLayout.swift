import SwiftUI

/// Hosts one view and takes exactly the width its container proposes.
///
/// A plain stack reports at least the width of its content, so a content wider than the
/// container would push the container wider and then measure itself against that. Reporting the
/// proposed width instead keeps the measurement honest. With no proposed width (an unbounded
/// container) it reports the content's own width.
struct FittingWidthLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard let content = subviews.first else { return .zero }
        let ideal = content.sizeThatFits(.unspecified)
        return CGSize(width: proposal.width ?? ideal.width, height: ideal.height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        subviews.first?.place(at: CGPoint(x: bounds.midX, y: bounds.minY), anchor: .top, proposal: .unspecified)
    }
}
