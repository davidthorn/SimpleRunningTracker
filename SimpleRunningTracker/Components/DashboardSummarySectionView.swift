//
//  DashboardSummarySectionView.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct DashboardSummarySectionView: View {
    public let items: [DashboardSummaryItem]
    @State private var selectedPeriod: DashboardSummaryPeriod

    public init(items: [DashboardSummaryItem]) {
        self.items = items
        self._selectedPeriod = State(initialValue: .day)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Performance Summary", systemImage: "chart.line.uptrend.xyaxis")
                .font(.headline)
                .foregroundStyle(AppPalette.accent)

            Picker("Summary Period", selection: $selectedPeriod) {
                ForEach(DashboardSummaryPeriod.allCases, id: \.self) { period in
                    Text(period.rawValue).tag(period)
                }
            }
            .pickerStyle(.segmented)

            if let item = selectedItem {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(item.period.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(AppPalette.accent)
                            .frame(height: 26)
                            .padding(.horizontal, 10)
                            .background(Color.white.opacity(0.8), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                        Text("\(item.runCount) runs")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Spacer()
                    }

                    HStack {
                        DashboardSummaryStatView(title: "Total", value: item.totalDistanceText)
                        DashboardSummaryStatView(title: "Duration", value: item.totalDurationText)
                    }

                    HStack {
                        DashboardSummaryStatView(title: "Avg Dist", value: item.averageDistanceText)
                        DashboardSummaryStatView(title: "Avg Speed", value: item.averageSpeedText)
                    }
                }
                .padding(10)
                .background(Color.white.opacity(0.65), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            } else {
                Text("No data available for this period.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.65), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
    }

    private var selectedItem: DashboardSummaryItem? {
        items.first { item in
            item.period == selectedPeriod
        }
    }
}

#if DEBUG
#Preview {
    DashboardSummarySectionView(
        items: [
            DashboardSummaryItem(
                period: .day,
                runCount: 1,
                totalDistanceText: "4.20 km",
                totalDurationText: "30:00",
                averageDistanceText: "4.20 km",
                averageSpeedText: "2.90 m/s"
            ),
            DashboardSummaryItem(
                period: .week,
                runCount: 3,
                totalDistanceText: "15.00 km",
                totalDurationText: "01:42:00",
                averageDistanceText: "5.00 km",
                averageSpeedText: "3.00 m/s"
            )
        ]
    )
    .padding()
}
#endif
