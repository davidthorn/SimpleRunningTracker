//
//  LocationPermissionView.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct LocationPermissionView: View {
    public let authorizationState: LocationAuthorizationState
    public let requestPermissionAction: () -> Void

    public init(
        authorizationState: LocationAuthorizationState,
        requestPermissionAction: @escaping () -> Void
    ) {
        self.authorizationState = authorizationState
        self.requestPermissionAction = requestPermissionAction
    }

    public var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "location.slash.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(AppPalette.accent)

            Text("Location Access Required")
                .font(.title3.bold())

            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Button(action: requestPermissionAction) {
                Label("Allow Location Access", systemImage: "location.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(AppPalette.accent)
        }
        .softCard()
    }

    private var message: String {
        switch authorizationState {
        case .notDetermined:
            return "Grant location access to start route tracking and show live running metrics."
        case .denied:
            return "Location permission is denied. Enable access in Settings to start tracking."
        case .restricted:
            return "Location access is restricted on this device."
        case .authorizedWhenInUse, .authorizedAlways:
            return "Location is available."
        }
    }
}

#if DEBUG
#Preview {
    LocationPermissionView(authorizationState: .notDetermined, requestPermissionAction: {})
}
#endif
