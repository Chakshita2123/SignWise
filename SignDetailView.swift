//
//  SignDetailView.swift
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
            Color.appBG
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // MARK: - Hero Image
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(
                                    colors: [Color.appAccent, Color.appAccent2],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 220)
                        
                        VStack(spacing: 12) {
                            SignImage(imageName: sign.imageName, size: 160)
                            
                            Text(sign.word)
                                .font(.system(size: 28, weight: .black))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .shadow(color: Color.appAccent.opacity(0.15), radius: 12, x: 0, y: 4)
                    
                    // MARK: - Steps
                    VStack(spacing: 0) {
                        
                        StepCard(
                            number: "1",
                            title: "Hand Shape",
                            description: sign.handShape,
                            color: Color.appAccent
                        )
                        
                        // Connector
                        Rectangle()
                            .fill(Color.appAccent.opacity(0.2))
                            .frame(width: 2, height: 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 46)
                        
                        StepCard(
                            number: "2",
                            title: "Movement",
                            description: sign.movement,
                            color: Color.appAccent2
                        )
                        
                        // Connector
                        Rectangle()
                            .fill(Color.appAccent.opacity(0.2))
                            .frame(width: 2, height: 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 46)
                        
                        StepCard(
                            number: "💡",
                            title: "Memory Tip",
                            description: sign.tip,
                            color: Color(red: 0.95, green: 0.52, blue: 0.08)
                        )
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Mark as Learned Button
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
                        .foregroundColor(isLearned ? .white : .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            Group {
                                if isLearned {
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.08, green: 0.72, blue: 0.52),
                                            Color(red: 0.05, green: 0.55, blue: 0.40)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                } else {
                                    LinearGradient(
                                        colors: [
                                            Color.appAccent,
                                            Color.appAccent2
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                }
                            }
                        )
                        .cornerRadius(18)
                        .padding(.horizontal)
                        .shadow(color: Color.appAccent.opacity(0.2), radius: 8, x: 0, y: 3)
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
            
            Text(number)
                .font(.system(size: 15, weight: .bold))
                .frame(width: 36, height: 36)
                .background(color.opacity(0.15))
                .foregroundColor(color)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(color)
                Text(description)
                    .font(.system(size: 16))
                    .foregroundColor(.appText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.appCard)
        .cornerRadius(16)
        .shadow(color: color.opacity(0.08), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    NavigationView {
        SignDetailView(sign: allSigns[0])
    }
}