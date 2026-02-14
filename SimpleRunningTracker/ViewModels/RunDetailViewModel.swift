//
//  RunDetailViewModel.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import Combine
import Foundation

@MainActor
public final class RunDetailViewModel: ObservableObject {
    private static let runDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    public let run: RunRecord

    public init(run: RunRecord) {
        self.run = run
    }

    public var statItems: [RunStatItem] {
        [
            RunStatItem(title: "Distance", value: distanceText(run.distanceMeters)),
            RunStatItem(title: "Duration", value: durationText(run.duration)),
            RunStatItem(title: "Avg Speed", value: speedText(run.averageSpeedMetersPerSecond)),
            RunStatItem(title: "Max Speed", value: speedText(run.maxSpeedMetersPerSecond)),
            RunStatItem(title: "Elevation", value: elevationText(run.elevationGainMeters))
        ]
    }

    public var dateText: String {
        Self.runDateFormatter.string(from: run.startDate)
    }

    private func distanceText(_ meters: Double) -> String {
        String(format: "%.2f km", meters / 1000)
    }

    private func durationText(_ duration: TimeInterval) -> String {
        let totalSeconds = Int(duration)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func speedText(_ speedMetersPerSecond: Double) -> String {
        String(format: "%.2f m/s", speedMetersPerSecond)
    }

    private func elevationText(_ elevationMeters: Double) -> String {
        String(format: "%.0f m", elevationMeters)
    }
}
