//
//  ContentView.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct ContentView: View {
    @State private var selectedTab: AppTab

    private let serviceContainer: ServiceContainerProtocol

    public init(serviceContainer: ServiceContainerProtocol) {
        self.serviceContainer = serviceContainer
        self._selectedTab = State(initialValue: .dashboard)
    }

    public var body: some View {
        ZStack {
            AppPalette.screenGradient
                .ignoresSafeArea()

            TabView(selection: $selectedTab) {
                DashboardScene(
                    serviceContainer: serviceContainer,
                    onStartRunTapped: {
                        selectedTab = .tracking
                    }
                )
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
                .tag(AppTab.dashboard)

                RunTrackingScene(serviceContainer: serviceContainer)
                    .tabItem {
                        Label("Track", systemImage: "figure.run")
                    }
                    .tag(AppTab.tracking)

                RunHistoryScene(serviceContainer: serviceContainer)
                    .tabItem {
                        Label("History", systemImage: "clock.arrow.circlepath")
                    }
                    .tag(AppTab.history)
            }
            .tint(AppPalette.accent)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(Color.white.opacity(0.88), for: .tabBar)
        }
    }
}

#if DEBUG
#Preview {
    ContentView(serviceContainer: ServiceContainer())
}
#endif
