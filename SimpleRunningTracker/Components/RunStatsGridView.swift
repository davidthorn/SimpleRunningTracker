//
//  RunStatsGridView.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct RunStatsGridView: View {
    public let items: [RunStatItem]

    public init(items: [RunStatItem]) {
        self.items = items
    }

    public var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(items, id: \.self) { item in
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.caption)
                        .foregroundStyle(AppPalette.accent)
                    Text(item.value)
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(AppPalette.cardGradient)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(AppPalette.cardStrokeGradient, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
            }
        }
    }

    private var columns: [GridItem] {
        [GridItem(.flexible()), GridItem(.flexible())]
    }
}

#if DEBUG
#Preview {
    RunStatsGridView(
        items: [
            RunStatItem(title: "Distance", value: "5.00 km"),
            RunStatItem(title: "Speed", value: "2.90 m/s"),
            RunStatItem(title: "Direction", value: "87°"),
            RunStatItem(title: "Altitude", value: "42 m")
        ]
    )
    .padding()
}
#endif
