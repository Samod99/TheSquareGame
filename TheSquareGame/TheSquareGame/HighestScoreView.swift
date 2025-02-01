import SwiftUI

struct HighestScoreView: View {
    let highestScores: [String: Int]

    var body: some View {
        VStack(spacing: 20) {
            Text("Highest Scores")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            ForEach(["Easy", "Medium", "Hard"], id: \.self) { level in
                Text("\(level): \(highestScores[level] ?? 0)")
                    .font(.title2)
                    .padding()
            }

            Spacer()
        }
        .padding()
    }
}
