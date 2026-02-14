//
//  SimpleRunningTrackerApp.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

@main
public struct SimpleRunningTrackerApp: App {
    private let serviceContainer: ServiceContainerProtocol

    public init() {
        self.serviceContainer = ServiceContainer()
    }

    public var body: some Scene {
        WindowGroup {
            ContentView(serviceContainer: serviceContainer)
        }
    }
}
