//
//  RunHistoryView.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct RunHistoryView: View {
    @StateObject private var viewModel: RunHistoryViewModel

    public init(serviceContainer: ServiceContainerProtocol) {
        let vm = RunHistoryViewModel(runStore: serviceContainer.runStore)
        self._viewModel = StateObject(wrappedValue: vm)
    }

    public var body: some View {
        List {
            if viewModel.runs.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "map.circle")
                        .font(.system(size: 40))
                        .foregroundStyle(AppPalette.accent)
                    Text("No runs tracked yet.")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
                .softCard()
            } else {
                ForEach(viewModel.rows, id: \.self) { row in
                    NavigationLink(value: RunHistoryRoute.detail(row.run)) {
                        RunHistoryRowView(row: row)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .appScreenBackground()
        .navigationTitle("Run History")
        .task {
            if Task.isCancelled {
                return
            }
            await viewModel.observeRuns()
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        RunHistoryView(serviceContainer: ServiceContainer())
    }
}
#endif
