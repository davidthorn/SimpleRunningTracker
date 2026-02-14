//
//  SoftCardModifier.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct SoftCardModifier: ViewModifier {
    private let cornerRadius: CGFloat
    private let contentPadding: CGFloat

    public init(cornerRadius: CGFloat = 18, contentPadding: CGFloat = 14) {
        self.cornerRadius = cornerRadius
        self.contentPadding = contentPadding
    }

    public func body(content: Content) -> some View {
        content
            .padding(contentPadding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(AppPalette.cardGradient)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(AppPalette.cardStrokeGradient, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 5)
    }
}
