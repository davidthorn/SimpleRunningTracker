//
//  ServiceContainer.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

@MainActor
public final class ServiceContainer: ServiceContainerProtocol {
    public let runStore: RunStoreProtocol
    public let locationService: LocationServiceProtocol

    public init() {
        self.runStore = RunStore()
        self.locationService = LocationService()
    }

    public init(
        runStore: RunStoreProtocol,
        locationService: LocationServiceProtocol
    ) {
        self.runStore = runStore
        self.locationService = locationService
    }
}
