//
//  AppScreenBackgroundModifier.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct AppScreenBackgroundModifier: ViewModifier {
    public init() {}

    public func body(content: Content) -> some View {
        ZStack {
            AppPalette.screenGradient
                .ignoresSafeArea()

            content
        }
    }
}
