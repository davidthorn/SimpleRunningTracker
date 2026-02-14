//
//  RunHistoryRow.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

public struct RunHistoryRow: Hashable {
    public let run: RunRecord
    public let title: String
    public let subtitle: String

    public init(run: RunRecord, title: String, subtitle: String) {
        self.run = run
        self.title = title
        self.subtitle = subtitle
    }
}
