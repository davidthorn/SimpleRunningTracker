//
//  RunStoreProtocol.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

/// Defines persistence and streaming operations for stored run records.
public protocol RunStoreProtocol: Sendable {
    /// Returns an asynchronous stream that emits all runs whenever data changes.
    func runsStream() async -> AsyncStream<[RunRecord]>

    /// Fetches the current list of runs.
    func fetchRuns() async -> [RunRecord]

    /// Persists a run record.
    /// - Parameter run: The run to save.
    func saveRun(_ run: RunRecord) async throws
}
