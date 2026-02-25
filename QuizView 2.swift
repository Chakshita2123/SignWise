//
//  QuizView.swift
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
            Color.appBG
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
                                .foregroundColor(.appSubtext)
                            Spacer()
                            Text("Score: \(score)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.appAccent)
                        }
                        
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.appAccent.opacity(0.1))
                                .frame(height: 6)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(LinearGradient(
                                    colors: [Color.appAccent, Color.appAccent2],
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
                            .fill(
                                LinearGradient(
                                    colors: [Color.appAccent, Color.appAccent2],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        VStack(spacing: 12) {
                            Text("✋")
                                .font(.system(size: 70))
                            
                            Text("What does this sign mean?")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(currentSign.handShape)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Text(currentSign.movement)
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.85))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(24)
                    }
                    .frame(height: 220)
                    .padding(.horizontal)
                    .shadow(color: Color.appAccent.opacity(0.15), radius: 12, x: 0, y: 4)
                    
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
                                            .foregroundColor(option == currentSign.word ? Color(red: 0.08, green: 0.72, blue: 0.52) : Color(red: 0.92, green: 0.22, blue: 0.32))
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
            return Color.appCard
        }
        if option == currentSign.word {
            return Color(red: 0.08, green: 0.72, blue: 0.52).opacity(0.15)
        }
        if option == selected {
            return Color(red: 0.92, green: 0.22, blue: 0.32).opacity(0.15)
        }
        return Color.appCard
    }
    
    func optionTextColor(_ option: String) -> Color {
        guard let selected = selectedAnswer else {
            return .appText
        }
        if option == currentSign.word { return Color(red: 0.08, green: 0.72, blue: 0.52) }
        if option == selected { return Color(red: 0.92, green: 0.22, blue: 0.32) }
        return .appSubtext
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
                .foregroundColor(.appText)
            
            // Score Circle
            ZStack {
                Circle()
                    .stroke(Color.appAccent.opacity(0.15), lineWidth: 12)
                Circle()
                    .trim(from: 0, to: CGFloat(percentage) / 100)
                    .stroke(
                        LinearGradient(
                            colors: [Color.appAccent, Color.appAccent2],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 4) {
                    Text("\(score)/\(total)")
                        .font(.system(size: 36, weight: .black))
                        .foregroundColor(.appText)
                    Text("correct")
                        .font(.system(size: 14))
                        .foregroundColor(.appSubtext)
                }
            }
            .frame(width: 160, height: 160)
            
            // Performance Message
            VStack(spacing: 8) {
                Text(percentage >= 70 ? "Excellent performance! 🌟" : "Keep practicing! 📖")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.appAccent)
                Text("\(percentage)% Accuracy")
                    .font(.system(size: 14))
                    .foregroundColor(.appSubtext)
            }
            .padding(16)
            .background(Color.appCard)
            .cornerRadius(14)
            .padding(.horizontal)
            
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
                            colors: [Color.appAccent, Color.appAccent2],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(18)
                    .padding(.horizontal)
                    .shadow(color: Color.appAccent.opacity(0.2), radius: 8, x: 0, y: 3)
            }
            
            Spacer()
        }
        .background(Color.appBG.ignoresSafeArea())
    }
}

#Preview {
    NavigationView {
        QuizView(category: .greetings)
    }
}