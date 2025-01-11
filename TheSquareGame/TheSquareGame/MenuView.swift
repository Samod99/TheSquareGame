import SwiftUI

struct MenuView: View {
    @State private var highestScore: Int = 0 // Placeholder for the highest score
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Game's Name
                Text("Match the Colors")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding()

                // Start Game Button
                NavigationLink(destination: ContentView(highestScore: $highestScore)) {
                    Text("Start Game")
                        .font(.title2)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                // Highest Score Button
                NavigationLink(destination: HighestScoreView(highestScore: highestScore)) {
                    Text("Highest Score")
                        .font(.title2)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                // Guidelines Button
                NavigationLink(destination: GuidelinesView()) {
                    Text("Guidelines")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                // Exit Button
                Button(action: {
                    exit(0) // Close the app
                }) {
                    Text("Exit")
                        .font(.title2)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}
