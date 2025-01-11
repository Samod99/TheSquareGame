//
//  HighestScoreView.swift
//  TheSquareGame
//
//  Created by Samod 037       on 2025-01-11.
//

import SwiftUI

struct HighestScoreView: View {
    let highestScore: Int // Pass the highest score to this view
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Highest Score")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("The highest score achieved is: \(highestScore)")
                .font(.title2)
                .padding()

            Spacer()
        }
        .padding()
    }
}
