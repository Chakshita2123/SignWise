//
//  SwiftUIView.swift
//  SignWise
//
//  Created by Student on 25/02/26.
//

import SwiftUI

struct SignDetailView: View {
    let sign: Sign
    @State var isLearned: Bool = false
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.12)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // Sign Word Hero
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white.opacity(0.07))
                            .frame(height: 200)
                        
                        VStack(spacing: 12) {
                            Text("✋")
                                .font(.system(size: 80))
                            Text(sign.word)
                                .font(.system(size: 28, weight: .black))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Steps
                    VStack(spacing: 0) {
                        StepCard(number: "1", title: "Hand Shape", description: sign.handShape, color: Color(red: 0.4, green: 0.6, blue: 1.0))
                        
                        // Connector
                        Rectangle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 2, height: 16)
                            .padding(.leading, 34)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 32)
                        
                        StepCard(number: "2", title: "Movement", description: sign.movement, color: Color(red: 0.6, green: 0.4, blue: 1.0))
                        
                        // Connector
                        Rectangle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 2, height: 16)
                            .padding(.leading, 34)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 32)
                        
                        StepCard(number: "💡", title: "Memory Tip", description: sign.tip, color: Color(red: 1.0, green: 0.7, blue: 0.2))
                    }
                    .padding(.horizontal)
                    
                    // Mark as Learned Button
                    Button {
                        isLearned.toggle()
                        UserDefaults.standard.set(isLearned, forKey: sign.id.uuidString)
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: isLearned ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 20))
                            Text(isLearned ? "Learned! 🎉" : "Mark as Learned")
                                .font(.system(size: 17, weight: .bold))
                        }
                        .foregroundColor(isLearned ? Color(red: 0.05, green: 0.05, blue: 0.12) : .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            Group {
                                if isLearned {
                                    Color.green
                                } else {
                                    LinearGradient(
                                        colors: [Color(red: 0.4, green: 0.6, blue: 1.0), Color(red: 0.6, green: 0.4, blue: 1.0)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                }
                            }
                        )
                        .cornerRadius(18)
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isLearned = UserDefaults.standard.bool(forKey: sign.id.uuidString)
        }
    }
}

// MARK: - Step Card
struct StepCard: View {
    let number: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            
            // Number Badge
            Text(number)
                .font(.system(size: 15, weight: .bold))
                .frame(width: 36, height: 36)
                .background(color.opacity(0.2))
                .foregroundColor(color)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(color)
                Text(description)
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.85))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
}

#Preview {
    NavigationView {
        SignDetailView(sign: allSigns[0])
    }
}
