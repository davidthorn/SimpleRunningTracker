//
//  RunHistoryRowView.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct RunHistoryRowView: View {
    public let row: RunHistoryRow

    public init(row: RunHistoryRow) {
        self.row = row
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RouteMapView(
                points: row.run.points,
                currentPoint: nil,
                showsUserLocation: false
            )
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 4) {
                Text(row.title)
                    .font(.headline)
                Text(row.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .softCard(cornerRadius: 16, contentPadding: 10)
        .padding(.vertical, 6)
    }
}

#if DEBUG
#Preview {
    RunHistoryRowView(
        row: RunHistoryRow(
            run: .sample,
            title: "14 Feb 2026 at 10:10",
            subtitle: "4.20 km • 30 min"
        )
    )
    .padding()
}
#endif
