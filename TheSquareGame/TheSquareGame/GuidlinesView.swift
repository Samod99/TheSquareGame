//
//  GuidlinesView.swift
//  TheSquareGame
//
//  Created by Samod 037       on 2025-01-11.
//

import SwiftUI

struct GuidelinesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Guidelines")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("""
            - Match buttons of the same color to score points.
            - You have 60 seconds to score as many points as possible.
            - Use the reset button to restart the game anytime.
            """)
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding()

            Spacer()
        }
        .padding()
    }
}
