//
//  SwiftUIView.swift
//  SignWise
//
//  Created by Student on 25/02/26.
//

import SwiftUI

struct QuizView: View {
    let category: SignCategory
    
    var signs: [Sign] {
        allSigns.filter { $0.category == category }.shuffled()
    }
    
    @State var currentIndex: Int = 0
    @State var selectedAnswer: String? = nil
    @State var score: Int = 0
    @State var showResult: Bool = false
    @State var options: [String] = []
    
    var currentSign: Sign {
        signs[currentIndex]
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.12)
                .ignoresSafeArea()
            
            if showResult {
                ResultView(score: score, total: signs.count, category: category)
            } else {
                VStack(spacing: 24) {
                    
                    // Progress Bar
                    VStack(spacing: 8) {
                        HStack {
                            Text("Question \(currentIndex + 1) of \(signs.count)")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.5))
                            Spacer()
                            Text("Score: \(score)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 6)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(LinearGradient(
                                    colors: [Color(red: 0.4, green: 0.6, blue: 1.0), Color(red: 0.6, green: 0.4, blue: 1.0)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ))
                                .frame(width: UIScreen.main.bounds.width * 0.85 * CGFloat(currentIndex + 1) / CGFloat(signs.count), height: 6)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Sign Card
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white.opacity(0.07))
                        
                        VStack(spacing: 12) {
                            Text("✋")
                                .font(.system(size: 70))
                            
                            Text("What does this sign mean?")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.5))
                            
                            Text(currentSign.handShape)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Text(currentSign.movement)
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(24)
                    }
                    .frame(height: 220)
                    .padding(.horizontal)
                    
                    // Answer Options
                    VStack(spacing: 12) {
                        ForEach(options, id: \.self) { option in
                            Button {
                                if selectedAnswer == nil {
                                    selectedAnswer = option
                                    if option == currentSign.word {
                                        score += 1
                                    }
                                    // Auto next after 1 second
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        if currentIndex + 1 < signs.count {
                                            currentIndex += 1
                                            selectedAnswer = nil
                                            generateOptions()
                                        } else {
                                            showResult = true
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(option)
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(optionTextColor(option))
                                    Spacer()
                                    if selectedAnswer == option {
                                        Image(systemName: option == currentSign.word ? "checkmark.circle.fill" : "xmark.circle.fill")
                                            .foregroundColor(option == currentSign.word ? .green : .red)
                                    }
                                }
                                .padding(18)
                                .background(optionBackground(option))
                                .cornerRadius(14)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
        }
        .navigationTitle("Quiz")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            generateOptions()
        }
    }
    
    // Generate 4 options with 1 correct
    func generateOptions() {
        let correct = currentSign.word
        var wrong = allSigns
            .filter { $0.word != correct }
            .map { $0.word }
            .shuffled()
            .prefix(3)
        
        var opts = Array(wrong) + [correct]
        opts.shuffle()
        options = opts
    }
    
    func optionBackground(_ option: String) -> Color {
        guard let selected = selectedAnswer else {
            return Color.white.opacity(0.07)
        }
        if option == currentSign.word {
            return Color.green.opacity(0.3)
        }
        if option == selected {
            return Color.red.opacity(0.3)
        }
        return Color.white.opacity(0.07)
    }
    
    func optionTextColor(_ option: String) -> Color {
        guard let selected = selectedAnswer else {
            return .white
        }
        if option == currentSign.word { return .green }
        if option == selected { return .red }
        return .white.opacity(0.4)
    }
}

// MARK: - Result View
struct ResultView: View {
    let score: Int
    let total: Int
    let category: SignCategory
    @Environment(\.presentationMode) var presentationMode
    
    var percentage: Int {
        Int(Double(score) / Double(total) * 100)
    }
    
    var message: String {
        switch percentage {
        case 90...100: return "Perfect! 🏆"
        case 70...89:  return "Great job! 🎉"
        case 50...69:  return "Keep going! 💪"
        default:       return "Try again! 📚"
        }
    }
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Text(category.emoji)
                .font(.system(size: 70))
            
            Text(message)
                .font(.system(size: 32, weight: .black))
                .foregroundColor(.white)
            
            // Score Circle
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 12)
                Circle()
                    .trim(from: 0, to: CGFloat(percentage) / 100)
                    .stroke(
                        LinearGradient(
                            colors: [Color(red: 0.4, green: 0.6, blue: 1.0), Color(red: 0.6, green: 0.4, blue: 1.0)],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 4) {
                    Text("\(score)/\(total)")
                        .font(.system(size: 36, weight: .black))
                        .foregroundColor(.white)
                    Text("correct")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            .frame(width: 160, height: 160)
            
            // Back Button
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Back to Category")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            colors: [Color(red: 0.4, green: 0.6, blue: 1.0), Color(red: 0.6, green: 0.4, blue: 1.0)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(18)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
    }
}

#Preview {
    NavigationView {
        QuizView(category: .greetings)
    }
}
