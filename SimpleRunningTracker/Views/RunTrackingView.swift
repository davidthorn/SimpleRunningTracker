//
//  RunTrackingView.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct RunTrackingView: View {
    @StateObject private var viewModel: RunTrackingViewModel

    public init(serviceContainer: ServiceContainerProtocol) {
        let vm = RunTrackingViewModel(
            runStore: serviceContainer.runStore,
            locationService: serviceContainer.locationService
        )
        self._viewModel = StateObject(wrappedValue: vm)
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if viewModel.authorizationState.isAuthorized {
                    ExpandableRouteMapView(
                        points: viewModel.routePoints,
                        currentPoint: viewModel.currentPoint,
                        showsUserLocation: true,
                        overlayStats: viewModel.statItems,
                        collapsedHeight: 320
                    )
                    .softCard(cornerRadius: 20, contentPadding: 8)

                    RunStatsGridView(items: viewModel.statItems)
                        .softCard()

                    controlsSection
                        .softCard()
                } else {
                    LocationPermissionView(
                        authorizationState: viewModel.authorizationState,
                        requestPermissionAction: {
                            Task {
                                if Task.isCancelled {
                                    return
                                }
                                await viewModel.requestAuthorization()
                            }
                        }
                    )
                }
            }
            .padding()
        }
        .appScreenBackground()
        .navigationTitle("Track Run")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.isTracking {
                    Button {
                        Task {
                            if Task.isCancelled {
                                return
                            }
                            if viewModel.isPaused {
                                await viewModel.resumeRun()
                            } else {
                                await viewModel.pauseRun()
                            }
                        }
                    } label: {
                        Image(systemName: viewModel.isPaused ? "play.circle.fill" : "pause.circle.fill")
                    }
                    .tint(AppPalette.accent)
                    .accessibilityLabel(viewModel.isPaused ? "Resume Run" : "Pause Run")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.isTracking {
                    Button {
                        Task {
                            if Task.isCancelled {
                                return
                            }
                            await viewModel.finishRun()
                        }
                    } label: {
                        Image(systemName: "flag.checkered.circle.fill")
                    }
                    .tint(AppPalette.accent)
                    .accessibilityLabel("Finish Run")
                }
            }
        }
        .task {
            if Task.isCancelled {
                return
            }
            await viewModel.observeAuthorizationStream()
        }
        .task {
            if Task.isCancelled {
                return
            }
            await viewModel.observeLocationStream()
        }
    }

    private var controlsSection: some View {
        VStack(spacing: 12) {
            if !viewModel.isTracking {
                Button {
                    Task {
                        if Task.isCancelled {
                            return
                        }
                        await viewModel.startRun()
                    }
                } label: {
                    Label("Start Run", systemImage: "figure.run.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(AppPalette.accent)
            } else {
                if viewModel.isPaused {
                    Button {
                        Task {
                            if Task.isCancelled {
                                return
                            }
                            await viewModel.resumeRun()
                        }
                    } label: {
                        Label("Resume", systemImage: "play.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(AppPalette.accent)
                } else {
                    Button {
                        Task {
                            if Task.isCancelled {
                                return
                            }
                            await viewModel.pauseRun()
                        }
                    } label: {
                        Label("Pause", systemImage: "pause.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(AppPalette.accent)
                }

                Button {
                    Task {
                        if Task.isCancelled {
                            return
                        }
                        await viewModel.finishRun()
                    }
                } label: {
                    Label("Finish Run", systemImage: "flag.checkered.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(AppPalette.accent)
            }
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        RunTrackingView(serviceContainer: ServiceContainer())
    }
}
#endif
