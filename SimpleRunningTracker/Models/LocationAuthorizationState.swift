//
//  LocationAuthorizationState.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import Foundation

public enum LocationAuthorizationState: Sendable {
    case notDetermined
    case denied
    case restricted
    case authorizedWhenInUse
    case authorizedAlways

    public var isAuthorized: Bool {
        switch self {
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        case .notDetermined, .denied, .restricted:
            return false
        }
    }
}
