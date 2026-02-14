//
//  DashboardScene.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct DashboardScene: View {
    private let serviceContainer: ServiceContainerProtocol
    private let onStartRunTapped: () -> Void

    public init(serviceContainer: ServiceContainerProtocol, onStartRunTapped: @escaping () -> Void) {
        self.serviceContainer = serviceContainer
        self.onStartRunTapped = onStartRunTapped
    }

    public var body: some View {
        NavigationStack {
            DashboardView(serviceContainer: serviceContainer, onStartRunTapped: onStartRunTapped)
        }
    }
}

#if DEBUG
#Preview {
    DashboardScene(serviceContainer: ServiceContainer(), onStartRunTapped: {})
}
#endif
