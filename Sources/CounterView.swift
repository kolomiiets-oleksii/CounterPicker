#if os(iOS)
//
//  CounterView.swift
//  CounterPicker
//
//  Created by Oleksii Kolomiiets on 10/25/25.
//

import SwiftUI

/// A scrollable wheel picker that mimics mechanical counter displays.
///
/// ``CounterView`` replicates the behavior of mechanical counters with separate displays
/// for whole and fractional digits. Each digit column shows the previous, current, and next
/// values with a scroll-wheel interaction. The component automatically adapts to light and
/// dark modes.
///
/// ## Configuration
///
/// The component supports customizable digit counts:
/// - **Whole digits:** Default 5 digits (0–99,999), configurable via `maxWhole`
/// - **Fractional digits:** Default 1 digit (0–9), up to 3 digits (0–999) via `maxFraction`
///
/// ## Usage
///
/// ### Basic usage with defaults
///
/// ```swift
/// @State var reading: Double = 0
/// CounterView(reading: $reading)
/// ```
///
/// ### Custom configuration
///
/// ```swift
/// @State var reading: Double = 0
/// CounterView(
///     reading: $reading,
///     maxWhole: 7,
///     maxFraction: 3
/// )
/// ```
public struct CounterView: View {
    @State private var counter: Counter
    @State private var availableWidth: CGFloat?
    @Binding private var reading: Double
    @ScaledMetric(relativeTo: .title3) private var preferredScale: CGFloat = 1

    /// Creates a counter view with optional digit configuration.
    ///
    /// - Parameters:
    ///   - reading: A binding to the counter's current reading.
    ///   - maxWhole: Maximum whole digits before the separator. Defaults to 5.
    ///   - maxFraction: Maximum fractional digits after the separator. Defaults to 1.
    public init(
        reading: Binding<Double>,
        maxWhole: Int? = nil,
        maxFraction: Int? = nil
    ) {
        self._reading = reading

        let value = reading.wrappedValue
        self.counter = Counter(
            reading: value,
            wholeDigitsCount: maxWhole,
            fractionDigitsCount: maxFraction
        )
    }

    private var scale: CGFloat {
        CounterLayout.scale(
            preferred: preferredScale,
            digitCount: counter.wholeDigits.count + counter.fractionDigits.count,
            availableWidth: availableWidth
        )
    }

    public var body: some View {
        let scale = scale
        FittingWidthLayout {
            HStack(spacing: 0) {
                ForEach(counter.wholeDigits.indices, id: \.self) { index in
                    DigitPickerView(value: $counter.wholeDigits[index], section: .whole, scale: scale)
                }

                SeparatorView(scale: scale)

                ForEach(counter.fractionDigits.indices, id: \.self) { index in
                    DigitPickerView(value: $counter.fractionDigits[index], section: .fractions, scale: scale)
                }
            }
            .padding(.horizontal, CounterLayout.wheelOverlap / 2 * scale)
            .pickerStyle(.wheel)
        }
        .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { availableWidth = $0 }
        .onChange(of: counter.wholeDigits) { _, newValue in
            if let newNumber = counter.value() {
                reading = newNumber
            }
        }
        .onChange(of: counter.fractionDigits) { _, _ in
            if let newNumber = counter.value() {
                reading = newNumber
            }
        }
        .onChange(of: reading) { _, newValue in
            withAnimation {
                counter.updateReading(newValue)
            }
        }
    }
}

#Preview {
    @Previewable @State var reading: Double = 2222.22
    NavigationStack {
        CounterView(
            reading: $reading,
            maxWhole: nil,
            maxFraction: 2
        )
        .onChange(of: reading) { oldValue, newValue in
            print(oldValue, newValue)
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    reading += Double.random(in: -400...999)
                } label: {
                    Text("Change")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle(Text("Reading: ") + Text(reading, format: .number))
        .navigationBarTitleDisplayMode(.inline)
    }
}
#endif
