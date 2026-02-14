//
//  LocationService.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import CoreLocation
import Foundation

@MainActor
public final class LocationService: NSObject, CLLocationManagerDelegate, LocationServiceProtocol {
    private let manager: CLLocationManager
    private var authorizationContinuations: [UUID: AsyncStream<LocationAuthorizationState>.Continuation]
    private var locationContinuations: [UUID: AsyncStream<LocationSample>.Continuation]

    public init(manager: CLLocationManager = CLLocationManager()) {
        self.manager = manager
        self.authorizationContinuations = [:]
        self.locationContinuations = [:]
        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .fitness
        manager.pausesLocationUpdatesAutomatically = false
    }

    public func currentAuthorizationState() -> LocationAuthorizationState {
        mapAuthorizationStatus(manager.authorizationStatus)
    }

    public func authorizationStream() -> AsyncStream<LocationAuthorizationState> {
        let continuationID = UUID()
        return AsyncStream<LocationAuthorizationState> { continuation in
            authorizationContinuations[continuationID] = continuation
            continuation.yield(currentAuthorizationState())

            continuation.onTermination = { _ in
                Task { @MainActor in
                    self.authorizationContinuations[continuationID] = nil
                }
            }
        }
    }

    public func locationStream() -> AsyncStream<LocationSample> {
        let continuationID = UUID()
        return AsyncStream<LocationSample> { continuation in
            locationContinuations[continuationID] = continuation
            continuation.onTermination = { _ in
                Task { @MainActor in
                    self.locationContinuations[continuationID] = nil
                }
            }
        }
    }

    public func requestWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
    }

    public func startLocationUpdates() {
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }

    public func stopLocationUpdates() {
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
    }

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let state = mapAuthorizationStatus(manager.authorizationStatus)
        for continuation in authorizationContinuations.values {
            continuation.yield(state)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }

        let sample = LocationSample(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            altitude: location.altitude,
            speedMetersPerSecond: max(0, location.speed),
            courseDegrees: max(0, location.course),
            timestamp: location.timestamp
        )

        for continuation in locationContinuations.values {
            continuation.yield(sample)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Keep stream alive; consumer can continue receiving future updates.
    }

    private func mapAuthorizationStatus(_ status: CLAuthorizationStatus) -> LocationAuthorizationState {
        switch status {
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .restricted
        case .denied:
            return .denied
        case .authorizedWhenInUse:
            return .authorizedWhenInUse
        case .authorizedAlways:
            return .authorizedAlways
        @unknown default:
            return .restricted
        }
    }
}
