//
//  AppPalette.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public enum AppPalette {
    public static let accent = Color(red: 0.84, green: 0.41, blue: 0.58)
    public static let accentSoft = Color(red: 0.93, green: 0.80, blue: 0.86)
    public static let cardBase = Color.white.opacity(0.82)
    public static let screenTop = Color(red: 0.99, green: 0.95, blue: 0.97)
    public static let screenBottom = Color(red: 0.95, green: 0.97, blue: 0.99)

    public static var screenGradient: LinearGradient {
        LinearGradient(
            colors: [screenTop, screenBottom],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    public static var cardGradient: LinearGradient {
        LinearGradient(
            colors: [cardBase, Color.white.opacity(0.65)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    public static var cardStrokeGradient: LinearGradient {
        LinearGradient(
            colors: [Color.white.opacity(0.85), accentSoft.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
