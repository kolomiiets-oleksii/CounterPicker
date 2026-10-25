#if os(iOS)
//
//  DigitPickerView.swift
//  CounterPicker
//
//  Created by Oleksii Kolomiiets on 10/25/25.
//

import SwiftUI

struct DigitPickerView: View {
    @Binding private var value: Int
    private var section: DigitSection
    private var scale: CGFloat

    init(value: Binding<Int>, section: DigitSection, scale: CGFloat = 1) {
        self._value = value
        self.section = section
        self.scale = scale
    }

    var body: some View {
        Picker("", selection: $value) {
            ForEach(0..<10) { value in
                Text("\(value)")
                    .font(.system(size: CounterLayout.digitFontSize * scale))
                    .tag(value)
                    .fontWeight(section.fontWeight)
                    .foregroundStyle(section.color)
            }
        }
        .frame(width: CounterLayout.wheelWidth * scale, height: CounterLayout.wheelHeight * scale)
        .clipped()
        .compositingGroup()
        .padding([.leading, .trailing], -CounterLayout.wheelOverlap / 2 * scale)
    }
}
#endif
