//
//  RunDetailView.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct RunDetailView: View {
    @StateObject private var viewModel: RunDetailViewModel

    public init(run: RunRecord) {
        let vm = RunDetailViewModel(run: run)
        self._viewModel = StateObject(wrappedValue: vm)
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Label(viewModel.dateText, systemImage: "calendar")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .softCard(cornerRadius: 16, contentPadding: 12)

                ExpandableRouteMapView(
                    points: viewModel.run.points,
                    currentPoint: nil,
                    collapsedHeight: 320
                )
                .softCard(cornerRadius: 20, contentPadding: 8)

                RunStatsGridView(items: viewModel.statItems)
                    .softCard()
            }
            .padding()
        }
        .appScreenBackground()
        .navigationTitle("Run Detail")
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        RunDetailView(run: .sample)
    }
}
#endif
