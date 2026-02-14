//
//  RunHistoryScene.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct RunHistoryScene: View {
    private let serviceContainer: ServiceContainerProtocol

    public init(serviceContainer: ServiceContainerProtocol) {
        self.serviceContainer = serviceContainer
    }

    public var body: some View {
        NavigationStack {
            RunHistoryView(serviceContainer: serviceContainer)
                .navigationDestination(for: RunHistoryRoute.self) { route in
                    switch route {
                    case .detail(let run):
                        RunDetailView(run: run)
                    }
                }
        }
    }
}

#if DEBUG
#Preview {
    RunHistoryScene(serviceContainer: ServiceContainer())
}
#endif
