//
//  LocationServiceProtocol.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

/// Defines location authorization and location update behavior for run tracking flows.
public protocol LocationServiceProtocol: AnyObject {
    /// Returns the current authorization status for location usage.
    func currentAuthorizationState() -> LocationAuthorizationState

    /// Returns a stream of authorization state changes.
    func authorizationStream() -> AsyncStream<LocationAuthorizationState>

    /// Returns a stream of location samples produced by the location service.
    func locationStream() -> AsyncStream<LocationSample>

    /// Requests when-in-use location authorization from the system.
    func requestWhenInUseAuthorization()

    /// Requests always authorization to support background tracking flows.
    func requestAlwaysAuthorization()

    /// Starts delivering location updates.
    func startLocationUpdates()

    /// Stops delivering location updates.
    func stopLocationUpdates()
}
