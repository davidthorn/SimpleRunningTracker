//
//  DashboardSummaryPeriod.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

public enum DashboardSummaryPeriod: String, CaseIterable, Hashable, Sendable {
    case day = "D"
    case week = "W"
    case month = "M"
    case sixMonths = "6M"
    case year = "Y"

    public var title: String {
        switch self {
        case .day:
            return "Day"
        case .week:
            return "Week"
        case .month:
            return "Month"
        case .sixMonths:
            return "6 Months"
        case .year:
            return "Year"
        }
    }
}
