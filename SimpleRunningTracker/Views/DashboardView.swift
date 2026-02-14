//
//  DashboardView.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel

    private let onStartRunTapped: () -> Void

    public init(serviceContainer: ServiceContainerProtocol, onStartRunTapped: @escaping () -> Void) {
        let vm = DashboardViewModel(runStore: serviceContainer.runStore)
        self._viewModel = StateObject(wrappedValue: vm)
        self.onStartRunTapped = onStartRunTapped
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection

                summarySection

                Button {
                    onStartRunTapped()
                } label: {
                    Label("Start Run", systemImage: "figure.run.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(AppPalette.accent)

                latestRunSection
            }
            .padding()
        }
        .appScreenBackground()
        .navigationTitle("Dashboard")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    onStartRunTapped()
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
                .tint(AppPalette.accent)
                .accessibilityLabel("Start Run")
            }
        }
        .task {
            if Task.isCancelled {
                return
            }
            await viewModel.observeRuns()
        }
    }

    private var headerSection: some View {
        HStack(spacing: 12) {
            Image(systemName: "heart.circle.fill")
                .font(.system(size: 36))
                .foregroundStyle(AppPalette.accent)

            VStack(alignment: .leading, spacing: 4) {
                Text("Your Running Space")
                    .font(.headline)
                Text("Track progress with calm, focused insights.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .softCard()
    }

    private var latestRunSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Last Run", systemImage: "clock.badge.checkmark")
                .font(.headline)
                .foregroundStyle(AppPalette.accent)

            if viewModel.latestRun != nil {
                if let latestRun = viewModel.latestRun {
                    RouteMapView(
                        points: latestRun.points,
                        currentPoint: nil,
                        showsUserLocation: false
                    )
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .allowsHitTesting(false)
                }

                RunStatsGridView(items: viewModel.latestRunStatItems)
            } else {
                Text("No runs tracked yet.")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .softCard()
    }

    private var summarySection: some View {
        DashboardSummarySectionView(items: viewModel.summaryItems)
            .softCard()
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        DashboardView(serviceContainer: ServiceContainer(), onStartRunTapped: {})
    }
}
#endif
