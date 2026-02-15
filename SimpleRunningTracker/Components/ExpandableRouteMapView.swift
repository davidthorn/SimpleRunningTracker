//
//  ExpandableRouteMapView.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct ExpandableRouteMapView: View {
    public let points: [RunPoint]
    public let currentPoint: RunPoint?
    public let showsUserLocation: Bool
    public let overlayStats: [RunStatItem]
    public let collapsedHeight: CGFloat

    @State private var isFullScreenPresented: Bool
    @State private var isStatsOverlayVisible: Bool

    public init(
        points: [RunPoint],
        currentPoint: RunPoint?,
        showsUserLocation: Bool = false,
        overlayStats: [RunStatItem] = [],
        collapsedHeight: CGFloat = 320
    ) {
        self.points = points
        self.currentPoint = currentPoint
        self.showsUserLocation = showsUserLocation
        self.overlayStats = overlayStats
        self.collapsedHeight = collapsedHeight
        self._isFullScreenPresented = State(initialValue: false)
        self._isStatsOverlayVisible = State(initialValue: true)
    }

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            RouteMapView(
                points: points,
                currentPoint: currentPoint,
                showsUserLocation: showsUserLocation
            )
                .frame(height: collapsedHeight)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            Button {
                isStatsOverlayVisible = true
                isFullScreenPresented = true
            } label: {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .font(.headline)
            }
            .buttonStyle(.bordered)
            .tint(AppPalette.accent)
            .background(.ultraThinMaterial, in: Circle())
            .padding(12)
            .accessibilityLabel("Open map full screen")
        }
        .fullScreenCover(isPresented: $isFullScreenPresented) {
            ZStack {
                RouteMapView(
                    points: points,
                    currentPoint: currentPoint,
                    showsUserLocation: showsUserLocation,
                    preservesUserCameraAfterInteraction: true
                )
                    .ignoresSafeArea()

                VStack {
                    HStack {
                        Spacer()
                        Button {
                            isFullScreenPresented = false
                        } label: {
                            Image(systemName: "arrow.down.right.and.arrow.up.left")
                                .font(.headline)
                        }
                        .buttonStyle(.bordered)
                        .tint(AppPalette.accent)
                        .background(.ultraThinMaterial, in: Circle())
                        .accessibilityLabel("Minimize map")
                    }

                    Spacer()

                    if !overlayStats.isEmpty {
                        if isStatsOverlayVisible {
                            MapStatsOverlayView(items: overlayStats) {
                                isStatsOverlayVisible = false
                            }
                        } else {
                            HStack {
                                Spacer()
                                Button {
                                    isStatsOverlayVisible = true
                                } label: {
                                    Label("Show Stats", systemImage: "chart.xyaxis.line")
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(AppPalette.accent)
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}

#if DEBUG
#Preview {
    ExpandableRouteMapView(points: RunRecord.sample.points, currentPoint: RunRecord.sample.points.last)
}
#endif
