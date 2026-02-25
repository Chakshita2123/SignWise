//
//  SwiftUIView.swift
//  SignWise
//
//  Created by Student on 25/02/26.
//

import SwiftUI

struct LearnView: View {
    let category: SignCategory
    
    var signs: [Sign] {
        allSigns.filter { $0.category == category }
    }
    
    var learnedCount: Int {
        signs.filter { UserDefaults.standard.bool(forKey: $0.id.uuidString) }.count
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.12)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    
                    // Header
                    VStack(spacing: 8) {
                        Text(category.emoji)
                            .font(.system(size: 60))
                        
                        Text(category.rawValue)
                            .font(.system(size: 30, weight: .black))
                            .foregroundColor(.white)
                        
                        Text("\(learnedCount) of \(signs.count) completed")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
                    // Quiz Button
                    NavigationLink(destination: QuizView(category: category)) {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: 20))
                            Text("Take Quiz")
                                .font(.system(size: 17, weight: .bold))
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.white)
                        .padding(18)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.4, green: 0.6, blue: 1.0), Color(red: 0.6, green: 0.4, blue: 1.0)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    
                    // Signs List
                    ForEach(signs) { sign in
                        NavigationLink(destination: SignDetailView(sign: sign)) {
                            SignRow(sign: sign)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Sign Row
struct SignRow: View {
    let sign: Sign
    
    var isLearned: Bool {
        UserDefaults.standard.bool(forKey: sign.id.uuidString)
    }
    
    var body: some View {
        HStack(spacing: 14) {
            
            // Check Icon
            ZStack {
                Circle()
                    .fill(isLearned ? Color.green : Color.white.opacity(0.1))
                    .frame(width: 36, height: 36)
                Image(systemName: isLearned ? "checkmark" : "hand.raised")
                    .foregroundColor(isLearned ? .white : .white.opacity(0.5))
                    .font(.system(size: 14, weight: .bold))
            }
            
            // Word
            VStack(alignment: .leading, spacing: 3) {
                Text(sign.word)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(sign.handShape)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.5))
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.3))
                .font(.system(size: 13))
        }
        .padding(16)
        .background(Color.white.opacity(0.07))
        .cornerRadius(16)
    }
}

#Preview {
    NavigationView {
        LearnView(category: .greetings)
    }
}
