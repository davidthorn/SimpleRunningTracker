//
//  DashboardViewModel.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import Combine
import Foundation

@MainActor
public final class DashboardViewModel: ObservableObject {
    private static let calendar: Calendar = .current

    @Published public private(set) var latestRun: RunRecord?
    @Published public private(set) var summaryItems: [DashboardSummaryItem]

    private let runStore: RunStoreProtocol

    public init(runStore: RunStoreProtocol) {
        self.runStore = runStore
        self.latestRun = nil
        self.summaryItems = []
    }

    public var latestRunStatItems: [RunStatItem] {
        guard let latestRun else {
            return []
        }

        return [
            RunStatItem(title: "Distance", value: String(format: "%.2f km", latestRun.distanceMeters / 1000)),
            RunStatItem(title: "Duration", value: durationText(latestRun.duration)),
            RunStatItem(title: "Avg Speed", value: String(format: "%.2f m/s", latestRun.averageSpeedMetersPerSecond)),
            RunStatItem(title: "Elevation", value: String(format: "%.0f m", latestRun.elevationGainMeters))
        ]
    }

    public func observeRuns() async {
        let stream = await runStore.runsStream()

        for await runs in stream {
            if Task.isCancelled {
                return
            }

            latestRun = runs.first
            summaryItems = makeSummaryItems(from: runs)
        }
    }

    private func makeSummaryItems(from runs: [RunRecord]) -> [DashboardSummaryItem] {
        let now = Date()
        return DashboardSummaryPeriod.allCases.map { period in
            let filteredRuns = runs.filter { run in
                run.startDate >= startDate(for: period, now: now)
            }

            let runCount = filteredRuns.count
            let totalDistance = filteredRuns.reduce(0) { partialResult, run in
                partialResult + run.distanceMeters
            }
            let totalDuration = filteredRuns.reduce(0) { partialResult, run in
                partialResult + run.duration
            }
            let averageDistance = runCount > 0 ? totalDistance / Double(runCount) : 0
            let averageSpeed = filteredRuns.isEmpty ? 0 : filteredRuns.reduce(0) { partialResult, run in
                partialResult + run.averageSpeedMetersPerSecond
            } / Double(runCount)

            return DashboardSummaryItem(
                period: period,
                runCount: runCount,
                totalDistanceText: String(format: "%.2f km", totalDistance / 1000),
                totalDurationText: durationText(totalDuration),
                averageDistanceText: String(format: "%.2f km", averageDistance / 1000),
                averageSpeedText: String(format: "%.2f m/s", averageSpeed)
            )
        }
    }

    private func startDate(for period: DashboardSummaryPeriod, now: Date) -> Date {
        switch period {
        case .day:
            return Self.calendar.date(byAdding: .day, value: -1, to: now) ?? now
        case .week:
            return Self.calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            return Self.calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .sixMonths:
            return Self.calendar.date(byAdding: .month, value: -6, to: now) ?? now
        case .year:
            return Self.calendar.date(byAdding: .year, value: -1, to: now) ?? now
        }
    }

    private func durationText(_ duration: TimeInterval) -> String {
        let totalSeconds = Int(duration)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
