import SwiftUI

struct ContentView: View {
    let level: String
    @Binding var highestScores: [String: Int]

    @State private var gridSize: Int
    @State private var buttonColors: [Color]
    @State private var selectedButtons: [Bool]
    @State private var disabledButtons: [Bool]
    @State private var score: Int = 0
    @State private var message: String = ""
    @State private var remainingTime: Int
    @State private var timer: Timer? = nil
    @State private var selectionsCount: Int = 0  // Track the number of selections (correct pairs)
    @State private var gameEnded: Bool = false // Track if the game has ended (when time is up)

    init(level: String, highestScores: Binding<[String: Int]>) {
        self.level = level
        self._highestScores = highestScores

        var tempGridSize: Int
        var tempRemainingTime: Int
        var colors: [Color] = []

        switch level {
        case "Medium":
            tempGridSize = 4
            tempRemainingTime = 45
            colors = [
                .blue, .blue, .green, .green, .red, .red, .yellow, .yellow,
                .orange, .orange, .black, .black, .pink, .pink, .purple, .purple
            ]
            colors.shuffle()
        case "Hard":
            tempGridSize = 5
            tempRemainingTime = 60
        default: // Easy Level
            tempGridSize = 3
            tempRemainingTime = 30
            colors = [.red, .red, .blue, .blue, .green, .green, .yellow, .yellow, .yellow]
            colors.shuffle()
        }

        self._gridSize = State(initialValue: tempGridSize)
        self._remainingTime = State(initialValue: tempRemainingTime)

        let totalButtons = tempGridSize * tempGridSize
        if colors.isEmpty {
            // Define the button colors for Medium Level
            colors = [
                .blue, .blue, .green, .green, .red, .red, .yellow, .yellow,
                .orange, .orange, .black, .black, .pink, .pink, .purple, .purple, .green, .green, .black, .black, .purple, .purple, .blue, .blue, .yellow
            ]
            colors.shuffle()
        }

        self._buttonColors = State(initialValue: colors)
        self._selectedButtons = State(initialValue: Array(repeating: false, count: totalButtons))
        self._disabledButtons = State(initialValue: Array(repeating: false, count: totalButtons))
    }

    func checkMatch() {
        guard !gameEnded else { return } // Don't allow any selections once the game has ended

        let selectedColors = zip(buttonColors, selectedButtons).filter { $0.1 }

        if selectedColors.count == 2 {
            if selectedColors[0].0 == selectedColors[1].0 {
                score += 1
                selectionsCount += 1  // Increase selection count after correct selection
                message = "Correct Selection!"

                if let firstIndex = selectedButtons.firstIndex(of: true),
                   let secondIndex = selectedButtons.lastIndex(of: true) {
                    disabledButtons[firstIndex] = true
                    disabledButtons[secondIndex] = true
                }
            } else {
                message = "Wrong Selection!"
            }
            selectedButtons = Array(repeating: false, count: gridSize * gridSize)
        }

        // Check if 16 selections (8 pairs) have been made
        if selectionsCount == 4 {
            reEnableAndShuffle()
        }
    }

    func reEnableAndShuffle() {
        message = "Shuffling colors!"
        disabledButtons = Array(repeating: false, count: gridSize * gridSize)
        buttonColors.shuffle()
        selectionsCount = 0  // Reset selection count to track the next set of 16 selections
    }

    func resetGame() {
        gameEnded = false  // Reset the gameEnded flag when resetting the game

        if score > highestScores[level] ?? 0 {
            highestScores[level] = score
            UserDefaults.standard.set(score, forKey: "\(level)HighestScore")
        }

        score = 0
        message = "Game Reset! Try Again."
        disabledButtons = Array(repeating: false, count: gridSize * gridSize)
        selectedButtons = Array(repeating: false, count: gridSize * gridSize)
        remainingTime = level == "Easy" ? 30 : 45

        if level == "Easy" {
            buttonColors = [.red, .red, .blue, .blue, .green, .green, .yellow, .yellow, .yellow]
            buttonColors.shuffle()
        } else if level == "Medium" {
            // Set up Medium Level colors
            buttonColors = [
                .blue, .blue, .green, .green, .red, .red, .yellow, .yellow,
                .orange, .orange, .black, .black, .pink, .pink, .purple, .purple
            ]
            buttonColors.shuffle()
        } else {
            buttonColors.shuffle()
        }

        selectionsCount = 0  // Reset the selection counter for the new game

        startTimer()
    }

    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                stopTimer()
                gameEnded = true  // Set the game as ended when time reaches 0
                message = "Game Over! Press Reset to play again."
                disableAllButtons() // Disable all buttons when time is up
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func disableAllButtons() {
        disabledButtons = Array(repeating: true, count: gridSize * gridSize) // Disable all buttons
    }

    var body: some View {
        VStack {
            HStack {
                Text("Score: \(score)")
                    .font(.title)
                Spacer()
                Text("Time: \(remainingTime) sec")
                    .font(.title)
                    .foregroundColor(remainingTime <= 10 ? .red : .black)
            }
            .padding()

            VStack(spacing: 10) {
                ForEach(0..<gridSize, id: \.self) { rowIndex in
                    HStack(spacing: 10) {
                        ForEach(0..<gridSize, id: \.self) { columnIndex in
                            let buttonIndex = rowIndex * gridSize + columnIndex
                            Button(action: {
                                if !disabledButtons[buttonIndex] {
                                    selectedButtons[buttonIndex].toggle()
                                    checkMatch()
                                }
                            }) {
                                Text("   ")
                                    .padding()
                                    .frame(width: 60, height: 60)
                                    .background(buttonColors[buttonIndex])
                                    .cornerRadius(10)
                                    .opacity(disabledButtons[buttonIndex] ? 0.4 : 1.0)
                            }
                            .disabled(disabledButtons[buttonIndex])
                        }
                    }
                }
            }

            Text(message)
                .font(.headline)
                .foregroundColor(.red)
                .padding(.top, 10)

            Button(action: { resetGame() }) {
                Text("Reset Game")
                    .font(.headline)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
        }
        .padding()
        .onAppear { startTimer() }
        .onDisappear { stopTimer() }
    }
}
