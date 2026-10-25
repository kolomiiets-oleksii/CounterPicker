#if os(iOS)
//
//  SeparatorView.swift
//  CounterPicker
//
//  Created by Oleksii Kolomiiets on 10/27/25.
//

import SwiftUI

struct SeparatorView: View {
    private enum Constant {
        static let separator: String = ","
    }

    var scale: CGFloat = 1

    var body: some View {
        Text(Constant.separator)
            .font(.system(size: CounterLayout.digitFontSize * scale, weight: .bold))
            .frame(width: CounterLayout.separatorWidth * scale)
            .padding(.top, 16 * scale)
    }
}
#endif
