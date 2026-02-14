//
//  ServiceContainerProtocol.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

/// Provides app-level service dependencies for scenes and views.
@MainActor
public protocol ServiceContainerProtocol {
    /// The run persistence and streaming service.
    var runStore: RunStoreProtocol { get }

    /// The location authorization and update service.
    var locationService: LocationServiceProtocol { get }
}
