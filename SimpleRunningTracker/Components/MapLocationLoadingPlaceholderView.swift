//
//  MapLocationLoadingPlaceholderView.swift
//  SimpleRunningTracker
//
//  Created by David Thorn on 14.02.2026.
//

import SwiftUI

public struct MapLocationLoadingPlaceholderView: View {
    public init() {}

    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(AppPalette.cardGradient)
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(AppPalette.cardStrokeGradient, lineWidth: 1)

            VStack(spacing: 12) {
                Image(systemName: "location.circle.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(AppPalette.accent)

                Text("Retrieving Current Location")
                    .font(.headline)

                ProgressView()
                    .controlSize(.regular)
            }
            .padding()
        }
    }
}

#if DEBUG
#Preview {
    MapLocationLoadingPlaceholderView()
        .frame(height: 320)
        .padding()
}
#endif
