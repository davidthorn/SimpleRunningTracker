//
//  MapStatsOverlayView.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct MapStatsOverlayView: View {
    public let items: [RunStatItem]
    public let dismissAction: () -> Void

    public init(items: [RunStatItem], dismissAction: @escaping () -> Void) {
        self.items = items
        self.dismissAction = dismissAction
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("Live Stats", systemImage: "waveform.path.ecg")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                Spacer()
                Button(action: dismissAction) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                .accessibilityLabel("Hide stats")
            }

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(items, id: \.self) { item in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.title)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(item.value)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .background(Color.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 6)
    }

    private var columns: [GridItem] {
        [GridItem(.flexible()), GridItem(.flexible())]
    }
}

#if DEBUG
#Preview {
    MapStatsOverlayView(
        items: [
            RunStatItem(title: "Distance", value: "3.12 km"),
            RunStatItem(title: "Speed", value: "3.02 m/s"),
            RunStatItem(title: "Direction", value: "92°"),
            RunStatItem(title: "Altitude", value: "42 m")
        ],
        dismissAction: {}
    )
    .padding()
}
#endif
