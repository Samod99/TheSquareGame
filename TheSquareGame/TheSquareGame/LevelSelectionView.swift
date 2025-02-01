import SwiftUI

struct LevelSelectionView: View {
    @Binding var highestScores: [String: Int]

    var body: some View {
        VStack(spacing: 30) {
            Text("Select Difficulty Level")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            ForEach(["Easy", "Medium", "Hard"], id: \.self) { level in
                NavigationLink(destination: ContentView(level: level, highestScores: $highestScores)) {
                    Text(level)
                        .font(.title2)
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
    }
}
