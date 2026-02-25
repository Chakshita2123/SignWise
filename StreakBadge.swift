//
//  StreakBadge.swift
//  SignWise
//
//  Created by Student on 25/02/26.
//

import SwiftUI

// MARK: - Small Badge (for Learn Screen)
struct StreakSmallBadge: View {
    @EnvironmentObject var streakManager: StreakManager
    
    var body: some View {
        HStack(spacing: 6) {
            Text(streakManager.streakEmoji)
                .font(.system(size: 16))
            Text("\(streakManager.currentStreak) days")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            LinearGradient(
                colors: [Color.appAccent, Color.appAccent2],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(20)
    }
}

// MARK: - Large Banner (for Home Screen)
struct StreakBanner: View {
    @EnvironmentObject var streakManager: StreakManager
    
    var body: some View {
        VStack(spacing: 16) {
            // Current Streak & Best
            HStack(spacing: 32) {
                // Current Streak
                VStack(spacing: 4) {
                    Text("\(streakManager.streakEmoji)")
                        .font(.system(size: 28))
                    Text("\(streakManager.currentStreak)")
                        .font(.system(size: 24, weight: .black))
                        .foregroundColor(.appText)
                    Text("Days")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.appSubtext)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(Color.appCard)
                .cornerRadius(16)
                
                // Best Streak
                VStack(spacing: 4) {
                    Text("🏆")
                        .font(.system(size: 28))
                    Text("\(streakManager.longestStreak)")
                        .font(.system(size: 24, weight: .black))
                        .foregroundColor(.appText)
                    Text("Best")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.appSubtext)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(Color.appCard)
                .cornerRadius(16)
            }
            
            // Message
            Text(streakManager.streakMessage)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.appAccent)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(Color.appAccent.opacity(0.08))
                .cornerRadius(12)
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [
                    Color.appAccent.opacity(0.05),
                    Color.appAccent2.opacity(0.03)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .border(Color.appAccent.opacity(0.1), width: 1.5)
    }
}

// MARK: - Quiz Result Streak Card
struct QuizStreakCard: View {
    @EnvironmentObject var streakManager: StreakManager
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Your Streak")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.appSubtext)
                HStack(spacing: 4) {
                    Text(streakManager.streakEmoji)
                        .font(.system(size: 20))
                    Text("\(streakManager.currentStreak) days")
                        .font(.system(size: 18, weight: .black))
                        .foregroundColor(.appAccent)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Best: \(streakManager.longestStreak)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.appSubtext)
                Text("🏆")
                    .font(.system(size: 24))
            }
        }
        .padding(16)
        .background(Color.appCard)
        .cornerRadius(16)
        .shadow(color: Color.appAccent.opacity(0.08), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Progress Screen Full Section
struct StreakProgressSection: View {
    @EnvironmentObject var streakManager: StreakManager
    
    var progressPercentage: Double {
        let targetDays = 30.0
        return min(Double(streakManager.currentStreak) / targetDays, 1.0)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("STREAK PROGRESS")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.appSubtext)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Main Streak Display
            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 4) {
                            Text(streakManager.streakEmoji)
                                .font(.system(size: 24))
                            Text("\(streakManager.currentStreak)")
                                .font(.system(size: 28, weight: .black))
                                .foregroundColor(.appText)
                        }
                        Text("Days in a Row")
                            .font(.system(size: 13))
                            .foregroundColor(.appSubtext)
                    }
                    
                    Spacer()
                    
                    // Circular Progress
                    ZStack {
                        Circle()
                            .stroke(Color.appAccent.opacity(0.15), lineWidth: 6)
                        Circle()
                            .trim(from: 0, to: progressPercentage)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.appAccent, Color.appAccent2],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 6, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                        
                        Text("\(Int(progressPercentage * 100))%")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.appAccent)
                    }
                    .frame(width: 70, height: 70)
                }
                
                // Progress Bar
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.appAccent.opacity(0.1))
                        .frame(height: 8)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [Color.appAccent, Color.appAccent2],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: (UIScreen.main.bounds.width - 48) * progressPercentage, height: 8)
                }
                
                HStack {
                    Text("Goal: 30 days")
                        .font(.system(size: 12))
                        .foregroundColor(.appSubtext)
                    Spacer()
                    Text("\(30 - streakManager.currentStreak) days left")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.appAccent)
                }
            }
            .padding(16)
            .background(Color.appCard)
            .cornerRadius(16)
            .shadow(color: Color.appAccent.opacity(0.08), radius: 8, x: 0, y: 2)
            
            // Stats Row
            HStack(spacing: 12) {
                VStack(spacing: 4) {
                    Text("Best Streak")
                        .font(.system(size: 12))
                        .foregroundColor(.appSubtext)
                    HStack(spacing: 4) {
                        Text("🏆")
                        Text("\(streakManager.longestStreak)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.appText)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(Color.appCard)
                .cornerRadius(12)
                
                VStack(spacing: 4) {
                    Text("Motivation")
                        .font(.system(size: 12))
                        .foregroundColor(.appSubtext)
                    Text("💪")
                        .font(.system(size: 18))
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(Color.appCard)
                .cornerRadius(12)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        StreakBanner()
        StreakSmallBadge()
        QuizStreakCard()
        StreakProgressSection()
    }
    .padding()
    .background(Color.appBG)
    .environmentObject(StreakManager())
}