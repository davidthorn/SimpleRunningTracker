//
//  DashboardSummaryItem.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

public struct DashboardSummaryItem: Hashable, Sendable {
    public let period: DashboardSummaryPeriod
    public let runCount: Int
    public let totalDistanceText: String
    public let totalDurationText: String
    public let averageDistanceText: String
    public let averageSpeedText: String

    public init(
        period: DashboardSummaryPeriod,
        runCount: Int,
        totalDistanceText: String,
        totalDurationText: String,
        averageDistanceText: String,
        averageSpeedText: String
    ) {
        self.period = period
        self.runCount = runCount
        self.totalDistanceText = totalDistanceText
        self.totalDurationText = totalDurationText
        self.averageDistanceText = averageDistanceText
        self.averageSpeedText = averageSpeedText
    }
}
