//
//  RunRecord.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

public struct RunRecord: Identifiable, Codable, Hashable, Sendable {
    public let id: UUID
    public let startDate: Date
    public let endDate: Date
    public let distanceMeters: Double
    public let elevationGainMeters: Double
    public let averageSpeedMetersPerSecond: Double
    public let maxSpeedMetersPerSecond: Double
    public let points: [RunPoint]

    public init(
        id: UUID,
        startDate: Date,
        endDate: Date,
        distanceMeters: Double,
        elevationGainMeters: Double,
        averageSpeedMetersPerSecond: Double,
        maxSpeedMetersPerSecond: Double,
        points: [RunPoint]
    ) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.distanceMeters = distanceMeters
        self.elevationGainMeters = elevationGainMeters
        self.averageSpeedMetersPerSecond = averageSpeedMetersPerSecond
        self.maxSpeedMetersPerSecond = maxSpeedMetersPerSecond
        self.points = points
    }

    public var duration: TimeInterval {
        endDate.timeIntervalSince(startDate)
    }
}
