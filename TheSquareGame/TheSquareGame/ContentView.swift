import SwiftUI

struct ContentView: View {
    // Define the state variables for button colors (9 buttons in total)
    @State private var buttonColors: [Color] = [
        .red, .blue, .red, .blue, .red, .blue, .red, .blue, .red
    ]

    // Define a state to track which buttons the user selects (9 buttons in total)
    @State private var selectedButtons: [Bool] = Array(repeating: false, count: 9)
    
    // Define the state to track which buttons are disabled
    @State private var disabledButtons: [Bool] = Array(repeating: false, count: 9)
    
    // Define the score variable
    @State private var score: Int = 0
    
    // Define a message to display when the user selects two buttons of different colors
    @State private var message: String = ""

    // Function to check for a match when two buttons are selected
    func checkMatch() {
        // Find which buttons are selected (true means selected)
        let selectedColors = zip(buttonColors, selectedButtons).filter { $0.1 == true }

        // If exactly two buttons are selected, check for a match
        if selectedColors.count == 2 {
            if selectedColors[0].0 == selectedColors[1].0 {
                score += 1
                message = "Correct Selection!" // Message for correct selection

                // Disable the selected buttons after a match
                if let firstSelectedIndex = selectedButtons.firstIndex(of: true),
                   let secondSelectedIndex = selectedButtons.lastIndex(of: true) {
                    disabledButtons[firstSelectedIndex] = true
                    disabledButtons[secondSelectedIndex] = true
                }
            } else {
                message = "Wrong Selection" // Message for wrong selection
            }
            
            // Reset selection after checking match
            selectedButtons = Array(repeating: false, count: 9)
        }
        
        // If the score reaches 4, reset the game
        if score == 4 {
            resetGame()
        }
    }

    // Function to reset the game
    func resetGame() {
        // Reset the score and message
        score = 0
        message = "Game Over! You won the previous one and Try Again."

        // Re-enable all buttons and reset the selection state
        disabledButtons = Array(repeating: false, count: 9)
        selectedButtons = Array(repeating: false, count: 9)
    }

    var body: some View {
        VStack {
            // Display the score
            Text("Score: \(score)")
                .font(.title)
                .padding()

            // Grid of buttons (3 rows of 3 buttons)
            VStack(spacing: 20) {
                ForEach(0..<3, id: \.self) { rowIndex in
                    HStack(spacing: 20) {
                        ForEach(0..<3, id: \.self) { columnIndex in
                            let buttonIndex = rowIndex * 3 + columnIndex
                            Button(action: {
                                // Only allow selection if the button is not disabled
                                if !disabledButtons[buttonIndex] {
                                    selectedButtons[buttonIndex].toggle()
                                    checkMatch() // Check for a match after each selection
                                }
                            }) {
                                Text("Button \(buttonIndex + 1)")
                                    .padding()
                                    .background(buttonColors[buttonIndex])
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .opacity(disabledButtons[buttonIndex] ? 0.4 : 1.0) // Dim disabled buttons
                            }
                            .disabled(disabledButtons[buttonIndex]) // Disable the button visually and functionally
                        }
                    }
                }
            }

            // Message displayed at the bottom
            Text(message)
                .font(.headline)
                .foregroundColor(.red)
                .padding(.top, 20)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
