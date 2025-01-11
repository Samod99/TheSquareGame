import SwiftUI

struct ContentView: View {
    // Added Binding for highest score
    @Binding var highestScore: Int
    
    // Define other state variables (same as earlier code)
    @State private var buttonColors: [Color] = [
        .red, .blue, .red, .blue, .red, .blue, .red, .blue, .red
    ]
    @State private var selectedButtons: [Bool] = Array(repeating: false, count: 9)
    @State private var disabledButtons: [Bool] = Array(repeating: false, count: 9)
    @State private var score: Int = 0
    @State private var message: String = ""
    @State private var remainingTime: Int = 60
    @State private var timer: Timer? = nil

    func checkMatch() {
        let selectedColors = zip(buttonColors, selectedButtons).filter { $0.1 == true }

        if selectedColors.count == 2 {
            if selectedColors[0].0 == selectedColors[1].0 {
                score += 1
                message = "Correct Selection!"

                if let firstSelectedIndex = selectedButtons.firstIndex(of: true),
                   let secondSelectedIndex = selectedButtons.lastIndex(of: true) {
                    disabledButtons[firstSelectedIndex] = true
                    disabledButtons[secondSelectedIndex] = true
                }
            } else {
                message = "Wrong Selection"
            }
            selectedButtons = Array(repeating: false, count: 9)
        }

        if score == 4 {
            message = "Game Over! You won! Press Reset to play again."
            stopTimer()
        }
    }

    func resetGame() {
        if score > highestScore {
            highestScore = score // Update highest score
        }
        score = 0
        message = "Game Reset! Try Again."
        disabledButtons = Array(repeating: false, count: 9)
        selectedButtons = Array(repeating: false, count: 9)
        remainingTime = 60
        startTimer()
    }

    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                message = "Time's up! The game has reset."
                resetGame()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
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

            VStack(spacing: 20) {
                ForEach(0..<3, id: \.self) { rowIndex in
                    HStack(spacing: 20) {
                        ForEach(0..<3, id: \.self) { columnIndex in
                            let buttonIndex = rowIndex * 3 + columnIndex
                            Button(action: {
                                if !disabledButtons[buttonIndex] {
                                    selectedButtons[buttonIndex].toggle()
                                    checkMatch()
                                }
                            }) {
                                Text("   ")
                                    .padding()
                                    .background(buttonColors[buttonIndex])
                                    .foregroundColor(.white)
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
                .padding(.top, 20)

            Button(action: {
                resetGame()
            }) {
                Text("Reset Game")
                    .font(.headline)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .padding()
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
}

struct GameApp_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
