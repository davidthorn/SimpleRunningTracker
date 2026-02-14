//
//  View+AppSurfaceModifiers.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public extension View {
    func softCard(cornerRadius: CGFloat = 18, contentPadding: CGFloat = 14) -> some View {
        modifier(SoftCardModifier(cornerRadius: cornerRadius, contentPadding: contentPadding))
    }

    func appScreenBackground() -> some View {
        modifier(AppScreenBackgroundModifier())
    }
}
