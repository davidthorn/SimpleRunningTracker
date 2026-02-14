//
//  RouteMapView.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import CoreLocation
import MapKit
import SwiftUI

public struct RouteMapView: View {
    public let points: [RunPoint]
    public let currentPoint: RunPoint?
    public let showsUserLocation: Bool

    @State private var cameraPosition: MapCameraPosition

    public init(
        points: [RunPoint],
        currentPoint: RunPoint?,
        showsUserLocation: Bool = true
    ) {
        self.points = points
        self.currentPoint = currentPoint
        self.showsUserLocation = showsUserLocation
        self._cameraPosition = State(initialValue: .automatic)
    }

    public var body: some View {
        Group {
            if shouldShowLocationPlaceholder {
                MapLocationLoadingPlaceholderView()
            } else {
                Map(position: $cameraPosition) {
                    if showsUserLocation {
                        UserAnnotation()
                    }

                    if points.count > 1 {
                        MapPolyline(coordinates: polylineCoordinates)
                            .stroke(.blue, lineWidth: 4)
                    }

                    if let startPoint = points.first {
                        Annotation(
                            "Start",
                            coordinate: CLLocationCoordinate2D(
                                latitude: startPoint.latitude,
                                longitude: startPoint.longitude
                            )
                        ) {
                            Image(systemName: "flag.circle.fill")
                                .font(.title3)
                                .foregroundStyle(.green)
                                .padding(2)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                    }

                    if points.count > 1, let endPoint = points.last {
                        Annotation(
                            "Finish",
                            coordinate: CLLocationCoordinate2D(
                                latitude: endPoint.latitude,
                                longitude: endPoint.longitude
                            )
                        ) {
                            Image(systemName: "flag.checkered.circle.fill")
                                .font(.title3)
                                .foregroundStyle(.red)
                                .padding(2)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                    }

                    if let currentPoint {
                        Annotation("Current", coordinate: CLLocationCoordinate2D(latitude: currentPoint.latitude, longitude: currentPoint.longitude)) {
                            Image(systemName: "figure.run.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.red)
                                .padding(4)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                    }
                }
                .mapStyle(.standard)
                .onAppear {
                    fitCameraIfNeeded()
                }
                .onChange(of: points.count) { _, _ in
                    fitCameraIfNeeded()
                }
                .onChange(of: currentPoint?.timestamp) { _, _ in
                    fitCameraIfNeeded()
                }
            }
        }
    }

    private var shouldShowLocationPlaceholder: Bool {
        points.isEmpty && currentPoint == nil
    }

    private var polylineCoordinates: [CLLocationCoordinate2D] {
        points.map { point in
            CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
        }
    }

    private func fitCameraIfNeeded() {
        if points.isEmpty {
            guard let currentPoint else {
                cameraPosition = .automatic
                return
            }

            let center = CLLocationCoordinate2D(latitude: currentPoint.latitude, longitude: currentPoint.longitude)
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: center,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            )
            return
        }

        if points.count == 1, let point = points.first {
            let center = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: center,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            )
            return
        }

        let coordinates = polylineCoordinates
        var minLatitude = coordinates[0].latitude
        var maxLatitude = coordinates[0].latitude
        var minLongitude = coordinates[0].longitude
        var maxLongitude = coordinates[0].longitude

        for coordinate in coordinates {
            minLatitude = min(minLatitude, coordinate.latitude)
            maxLatitude = max(maxLatitude, coordinate.latitude)
            minLongitude = min(minLongitude, coordinate.longitude)
            maxLongitude = max(maxLongitude, coordinate.longitude)
        }

        let center = CLLocationCoordinate2D(
            latitude: (minLatitude + maxLatitude) / 2,
            longitude: (minLongitude + maxLongitude) / 2
        )

        let span = MKCoordinateSpan(
            latitudeDelta: max((maxLatitude - minLatitude) * 1.4, 0.005),
            longitudeDelta: max((maxLongitude - minLongitude) * 1.4, 0.005)
        )

        cameraPosition = .region(MKCoordinateRegion(center: center, span: span))
    }
}

#if DEBUG
#Preview {
    RouteMapView(points: RunRecord.sample.points, currentPoint: RunRecord.sample.points.last)
}
#endif
