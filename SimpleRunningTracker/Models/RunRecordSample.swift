//
//  RunRecordSample.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

public extension RunRecord {
    static var sample: RunRecord {
        let startDate = Date().addingTimeInterval(-1800)
        let firstPoint = RunPoint(
            latitude: 37.3346,
            longitude: -122.0090,
            altitude: 12,
            speedMetersPerSecond: 2.8,
            courseDegrees: 70,
            timestamp: startDate
        )
        let secondPoint = RunPoint(
            latitude: 37.3360,
            longitude: -122.0055,
            altitude: 18,
            speedMetersPerSecond: 3.1,
            courseDegrees: 80,
            timestamp: startDate.addingTimeInterval(600)
        )
        let thirdPoint = RunPoint(
            latitude: 37.3385,
            longitude: -122.0020,
            altitude: 20,
            speedMetersPerSecond: 2.9,
            courseDegrees: 92,
            timestamp: startDate.addingTimeInterval(1200)
        )

        return RunRecord(
            id: UUID(),
            startDate: startDate,
            endDate: startDate.addingTimeInterval(1800),
            distanceMeters: 4200,
            elevationGainMeters: 35,
            averageSpeedMetersPerSecond: 2.9,
            maxSpeedMetersPerSecond: 3.4,
            points: [firstPoint, secondPoint, thirdPoint]
        )
    }
}
