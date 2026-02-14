//
//  RunTrackingScene.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct RunTrackingScene: View {
    private let serviceContainer: ServiceContainerProtocol

    public init(serviceContainer: ServiceContainerProtocol) {
        self.serviceContainer = serviceContainer
    }

    public var body: some View {
        NavigationStack {
            RunTrackingView(serviceContainer: serviceContainer)
        }
    }
}

#if DEBUG
#Preview {
    RunTrackingScene(serviceContainer: ServiceContainer())
}
#endif
