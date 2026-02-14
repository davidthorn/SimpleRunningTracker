//
//  RunStore.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

public actor RunStore: RunStoreProtocol {
    private var runs: [RunRecord]
    private var streamContinuations: [UUID: AsyncStream<[RunRecord]>.Continuation]
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let fileURL: URL

    public init() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        self.encoder = encoder

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder

        self.streamContinuations = [:]

        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first ?? URL(fileURLWithPath: NSTemporaryDirectory())
        self.fileURL = documentsDirectory.appendingPathComponent("runs.json")
        self.runs = []

        do {
            let data = try Data(contentsOf: fileURL)
            self.runs = try decoder.decode([RunRecord].self, from: data)
        } catch {
            self.runs = []
        }
    }

    public func runsStream() async -> AsyncStream<[RunRecord]> {
        let continuationID = UUID()
        return AsyncStream<[RunRecord]> { continuation in
            streamContinuations[continuationID] = continuation
            continuation.yield(sortedRuns())

            continuation.onTermination = { _ in
                Task {
                    await self.removeContinuation(id: continuationID)
                }
            }
        }
    }

    public func fetchRuns() async -> [RunRecord] {
        sortedRuns()
    }

    public func saveRun(_ run: RunRecord) async throws {
        runs.append(run)
        try persistRuns()
        broadcastRuns()
    }

    private func removeContinuation(id: UUID) {
        streamContinuations[id] = nil
    }

    private func sortedRuns() -> [RunRecord] {
        runs.sorted { $0.startDate > $1.startDate }
    }

    private func broadcastRuns() {
        let snapshot = sortedRuns()
        for continuation in streamContinuations.values {
            continuation.yield(snapshot)
        }
    }

    private func persistRuns() throws {
        let data = try encoder.encode(runs)
        try data.write(to: fileURL, options: .atomic)
    }
}
