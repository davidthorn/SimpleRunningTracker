//
//  RunTrackingViewModel.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import Combine
import CoreLocation
import Foundation

@MainActor
public final class RunTrackingViewModel: ObservableObject {
    @Published public private(set) var authorizationState: LocationAuthorizationState
    @Published public private(set) var isTracking: Bool
    @Published public private(set) var isPaused: Bool
    @Published public private(set) var distanceMeters: Double
    @Published public private(set) var currentSpeedMetersPerSecond: Double
    @Published public private(set) var headingDegrees: Double
    @Published public private(set) var altitudeMeters: Double
    @Published public private(set) var routePoints: [RunPoint]
    @Published public private(set) var currentLocationPoint: RunPoint?

    private let runStore: RunStoreProtocol
    private let locationService: LocationServiceProtocol

    private var startDate: Date?
    private var lastPoint: RunPoint?
    private var maxSpeedMetersPerSecond: Double
    private var elevationGainMeters: Double

    public init(runStore: RunStoreProtocol, locationService: LocationServiceProtocol) {
        self.runStore = runStore
        self.locationService = locationService

        self.authorizationState = locationService.currentAuthorizationState()
        self.isTracking = false
        self.isPaused = false
        self.distanceMeters = 0
        self.currentSpeedMetersPerSecond = 0
        self.headingDegrees = 0
        self.altitudeMeters = 0
        self.routePoints = []
        self.currentLocationPoint = nil

        self.startDate = nil
        self.lastPoint = nil
        self.maxSpeedMetersPerSecond = 0
        self.elevationGainMeters = 0

        if self.authorizationState.isAuthorized {
            self.locationService.startLocationUpdates()
        }
    }

    public var statItems: [RunStatItem] {
        [
            RunStatItem(title: "Distance", value: distanceText(distanceMeters)),
            RunStatItem(title: "Speed", value: speedText(currentSpeedMetersPerSecond)),
            RunStatItem(title: "Direction", value: directionText(headingDegrees)),
            RunStatItem(title: "Altitude", value: altitudeText(altitudeMeters))
        ]
    }

    public var currentPoint: RunPoint? {
        currentLocationPoint ?? routePoints.last
    }

    public func observeAuthorizationStream() async {
        let stream = locationService.authorizationStream()

        for await state in stream {
            if Task.isCancelled {
                return
            }

            authorizationState = state
            if state.isAuthorized {
                locationService.startLocationUpdates()
            } else {
                isTracking = false
                isPaused = false
                locationService.stopLocationUpdates()
            }
        }
    }

    public func observeLocationStream() async {
        let stream = locationService.locationStream()

        for await sample in stream {
            if Task.isCancelled {
                return
            }

            consumeSample(sample)
        }
    }

    public func requestAuthorization() async {
        switch authorizationState {
        case .notDetermined:
            locationService.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationService.requestAlwaysAuthorization()
        case .authorizedAlways, .denied, .restricted:
            break
        }
        authorizationState = locationService.currentAuthorizationState()
    }

    public func startRun() async {
        guard authorizationState.isAuthorized else {
            return
        }

        startDate = Date()
        lastPoint = nil
        maxSpeedMetersPerSecond = 0
        elevationGainMeters = 0
        distanceMeters = 0
        routePoints = []

        isTracking = true
        isPaused = false
    }

    public func pauseRun() async {
        guard isTracking else {
            return
        }

        isPaused = true
    }

    public func resumeRun() async {
        guard isTracking else {
            return
        }

        isPaused = false
    }

    public func finishRun() async {
        guard isTracking else {
            return
        }

        isTracking = false
        isPaused = false
        guard let runStartDate = startDate else {
            resetRunState()
            return
        }

        let now = Date()
        let duration = now.timeIntervalSince(runStartDate)
        if duration <= 0 || routePoints.count < 2 {
            resetRunState()
            return
        }

        let averageSpeed = distanceMeters / duration

        let run = RunRecord(
            id: UUID(),
            startDate: runStartDate,
            endDate: now,
            distanceMeters: distanceMeters,
            elevationGainMeters: elevationGainMeters,
            averageSpeedMetersPerSecond: averageSpeed,
            maxSpeedMetersPerSecond: maxSpeedMetersPerSecond,
            points: routePoints
        )

        do {
            try await runStore.saveRun(run)
        } catch {
            // Keep in-memory run state reset even if persistence fails.
        }

        resetRunState()
    }

    private func consumeSample(_ sample: LocationSample) {
        let point = RunPoint(
            latitude: sample.latitude,
            longitude: sample.longitude,
            altitude: sample.altitude,
            speedMetersPerSecond: sample.speedMetersPerSecond,
            courseDegrees: sample.courseDegrees,
            timestamp: sample.timestamp
        )
        currentLocationPoint = point

        currentSpeedMetersPerSecond = sample.speedMetersPerSecond
        headingDegrees = sample.courseDegrees
        altitudeMeters = sample.altitude

        guard isTracking, !isPaused else {
            return
        }

        if let previousPoint = lastPoint {
            let previousLocation = CLLocation(latitude: previousPoint.latitude, longitude: previousPoint.longitude)
            let currentLocation = CLLocation(latitude: point.latitude, longitude: point.longitude)
            let segmentDistance = currentLocation.distance(from: previousLocation)
            distanceMeters += max(0, segmentDistance)

            let altitudeDelta = point.altitude - previousPoint.altitude
            if altitudeDelta > 0 {
                elevationGainMeters += altitudeDelta
            }
        }

        maxSpeedMetersPerSecond = max(maxSpeedMetersPerSecond, point.speedMetersPerSecond)
        routePoints.append(point)
        lastPoint = point
    }

    private func resetRunState() {
        startDate = nil
        lastPoint = nil
        maxSpeedMetersPerSecond = 0
        elevationGainMeters = 0
        distanceMeters = 0
        routePoints = []
        currentSpeedMetersPerSecond = 0
        headingDegrees = 0
        altitudeMeters = 0
    }

    private func distanceText(_ meters: Double) -> String {
        String(format: "%.2f km", meters / 1000)
    }

    private func speedText(_ speedMetersPerSecond: Double) -> String {
        String(format: "%.2f m/s", speedMetersPerSecond)
    }

    private func directionText(_ headingDegrees: Double) -> String {
        String(format: "%.0f°", headingDegrees)
    }

    private func altitudeText(_ altitudeMeters: Double) -> String {
        String(format: "%.0f m", altitudeMeters)
    }
}
