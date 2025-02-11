import SwiftUI

struct ContentView: View {
    @State private var number = Int.random(in: 1...100) // Random number between 1-100
    @State private var correctAnswers = 0
    @State private var wrongAnswers = 0
    @State private var showFeedback = false
    @State private var isCorrect = false
    @State private var showScore = false
    @State private var attempts = 0
    
    // Timer for 5-second auto-update
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Text("\(number)")
                .font(.system(size: 50, weight: .bold))
                .padding()
            
            // Buttons for Prime and Not Prime
            HStack {
                Button(action: { checkAnswer(userThinksPrime: true) }) {
                    Text("Prime")
                        .font(.title)
                        .padding()
                        .background(Color.blue.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: { checkAnswer(userThinksPrime: false) }) {
                    Text("Not Prime")
                        .font(.title)
                        .padding()
                        .background(Color.red.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()

            // Show feedback (✔ for correct, ❌ for incorrect)
            if showFeedback {
                Text(isCorrect ? "✔" : "❌")
                    .font(.largeTitle)
                    .foregroundColor(isCorrect ? .green : .red)
                    .transition(.scale)
            }
        }
        .onReceive(timer) { _ in
            autoUpdateNumber() // Change number every 5 seconds
        }
        .alert(isPresented: $showScore) {
            Alert(
                title: Text("Score Summary"),
                message: Text("Correct: \(correctAnswers)\nWrong: \(wrongAnswers)"),
                dismissButton: .default(Text("OK"), action: resetGame)
            )
        }
    }

    // Function to check if a number is prime
    func isPrime(_ n: Int) -> Bool {
        if n < 2 { return false }
        for i in 2..<n {
            if n % i == 0 {
                return false
            }
        }
        return true
    }

    // Function to check user selection
    func checkAnswer(userThinksPrime: Bool) {
        let correct = userThinksPrime == isPrime(number) // No conflict anymore
        isCorrect = correct

        if correct {
            correctAnswers += 1
        } else {
            wrongAnswers += 1
        }

        showFeedback = true
        attempts += 1

        // Hide feedback and update number after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            showFeedback = false
            number = Int.random(in: 1...100)

            // Show score summary after 10 attempts
            if attempts >= 10 {
                showScore = true
            }
        }
    }

    // Function to auto-update number every 5 seconds
    func autoUpdateNumber() {
        number = Int.random(in: 1...100)
        wrongAnswers += 1 // Count as incorrect if no selection was made
        attempts += 1

        if attempts >= 10 {
            showScore = true
        }
    }

    // Function to reset game
    func resetGame() {
        correctAnswers = 0
        wrongAnswers = 0
        attempts = 0
    }
}