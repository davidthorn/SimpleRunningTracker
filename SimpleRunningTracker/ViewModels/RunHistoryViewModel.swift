//
//  RunHistoryViewModel.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import Combine
import Foundation

@MainActor
public final class RunHistoryViewModel: ObservableObject {
    private static let rowDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    @Published public private(set) var runs: [RunRecord]

    private let runStore: RunStoreProtocol

    public init(runStore: RunStoreProtocol) {
        self.runStore = runStore
        self.runs = []
    }

    public var rows: [RunHistoryRow] {
        runs.map { run in
            RunHistoryRow(
                run: run,
                title: Self.rowDateFormatter.string(from: run.startDate),
                subtitle: String(format: "%.2f km • %.0f min", run.distanceMeters / 1000, run.duration / 60)
            )
        }
    }

    public func observeRuns() async {
        let stream = await runStore.runsStream()

        for await runs in stream {
            if Task.isCancelled {
                return
            }

            self.runs = runs
        }
    }
}
