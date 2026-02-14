//
//  LocationSample.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

public struct LocationSample: Sendable {
    public let latitude: Double
    public let longitude: Double
    public let altitude: Double
    public let speedMetersPerSecond: Double
    public let courseDegrees: Double
    public let timestamp: Date

    public init(
        latitude: Double,
        longitude: Double,
        altitude: Double,
        speedMetersPerSecond: Double,
        courseDegrees: Double,
        timestamp: Date
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.speedMetersPerSecond = speedMetersPerSecond
        self.courseDegrees = courseDegrees
        self.timestamp = timestamp
    }
}
