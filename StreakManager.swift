//
//  StreakManager.swift
//  SignWise
//
//  Created by Student on 25/02/26.
//

import SwiftUI
import UserNotifications

class StreakManager: ObservableObject {
    // MARK: - Published Properties
    @Published var currentStreak: Int = 0
    @Published var longestStreak: Int = 0
    @Published var lastLearnedDate: Date?
    @Published var totalSignsLearnedToday: Int = 0
    @Published var streakMessage: String = ""
    @Published var streakEmoji: String = ""
    
    // MARK: - Private Keys
    private let currentStreakKey = "currentStreak"
    private let longestStreakKey = "longestStreak"
    private let lastLearnedDateKey = "lastLearnedDate"
    private let totalSignsTodayKey = "totalSignsLearnedToday"
    private let todayDateKey = "todayDate"
    
    // MARK: - Initialization
    init() {
        loadStreak()
        checkStreakStatus()
        requestNotificationPermission()
        updateStreakMessage()
    }
    
    // MARK: - Load Streak from UserDefaults
    func loadStreak() {
        currentStreak = UserDefaults.standard.integer(forKey: currentStreakKey)
        longestStreak = UserDefaults.standard.integer(forKey: longestStreakKey)
        lastLearnedDate = UserDefaults.standard.object(forKey: lastLearnedDateKey) as? Date
        
        // Reset daily counter if new day
        let today = Calendar.current.startOfDay(for: Date())
        if let lastDate = UserDefaults.standard.object(forKey: todayDateKey) as? Date {
            let lastDay = Calendar.current.startOfDay(for: lastDate)
            if today != lastDay {
                totalSignsLearnedToday = 0
            } else {
                totalSignsLearnedToday = UserDefaults.standard.integer(forKey: totalSignsTodayKey)
            }
        }
        UserDefaults.standard.set(today, forKey: todayDateKey)
    }
    
    // MARK: - Record Learning
    func recordLearning() {
        let today = Calendar.current.startOfDay(for: Date())
        let lastLearnedDay = lastLearnedDate.map { Calendar.current.startOfDay(for: $0) }
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        // Check if user learned something today
        if let lastDay = lastLearnedDay, lastDay == today {
            // Already learned today, just increment signs count
            totalSignsLearnedToday += 1
            saveStreak()
            return
        }
        
        // Check if streak should continue
        if let lastDay = lastLearnedDay, lastDay == yesterday {
            // Consecutive day - Streak continues
            currentStreak += 1
            sendStreakNotification(type: .streakIncrease)
        } else {
            // New streak or broken streak
            if currentStreak > 0 {
                sendStreakNotification(type: .streakBroken)
            }
            currentStreak = 1
        }
        
        // Update longest streak
        if currentStreak > longestStreak {
            longestStreak = currentStreak
            UserDefaults.standard.set(longestStreak, forKey: longestStreakKey)
            sendStreakNotification(type: .newRecord)
        }
        
        lastLearnedDate = Date()
        totalSignsLearnedToday = 1
        
        saveStreak()
        updateStreakMessage()
    }
    
    // MARK: - Check Streak Status
    func checkStreakStatus() {
        guard let lastDate = lastLearnedDate else { return }
        
        let today = Calendar.current.startOfDay(for: Date())
        let lastDay = Calendar.current.startOfDay(for: lastDate)
        let daysDifference = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0
        
        // If 2+ days since last learning, break the streak
        if daysDifference > 1 && currentStreak > 0 {
            currentStreak = 0
            UserDefaults.standard.set(currentStreak, forKey: currentStreakKey)
        }
    }
    
    // MARK: - Update Streak Message
    func updateStreakMessage() {
        if !isStreakActive() && currentStreak > 0 {
            streakEmoji = "😢"
            streakMessage = "Kal se phir start karo.\nAaj ek sign seekh lo!"
        } else if currentStreak == 0 {
            streakEmoji = "⏳"
            streakMessage = "Aaj ka pehla sign\nseekhne ka samay!"
        } else if currentStreak >= 7 {
            streakEmoji = "🔥"
            streakMessage = "Roz seekh rahe ho.\nShaandaar!"
        } else if currentStreak >= 5 {
            streakEmoji = "🎉"
            streakMessage = "Lagatar \(currentStreak) din –\nkeep it up!"
        } else if currentStreak >= 3 {
            streakEmoji = "🎯"
            streakMessage = "Chalo, ek din aur!\n\(currentStreak) din ho gaye!"
        } else if currentStreak == 1 {
            streakEmoji = "🌟"
            streakMessage = "Pehla din shuru ho gaya!\nAgle din 2 banao!"
        } else {
            streakEmoji = "💪"
            streakMessage = "Ek sign roz –\n5 minute bhi kaafi hai!"
        }
    }
    
    // MARK: - Save Streak
    func saveStreak() {
        UserDefaults.standard.set(currentStreak, forKey: currentStreakKey)
        UserDefaults.standard.set(lastLearnedDate, forKey: lastLearnedDateKey)
        UserDefaults.standard.set(totalSignsLearnedToday, forKey: totalSignsTodayKey)
    }
    
    // MARK: - Check Streak Status
    func isStreakActive() -> Bool {
        guard let lastDate = lastLearnedDate else { return false }
        let lastDay = Calendar.current.startOfDay(for: lastDate)
        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        return lastDay == today || lastDay == yesterday
    }
    
    // MARK: - Send Notifications
    func sendStreakNotification(type: NotificationType) {
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.badge = NSNumber(value: currentStreak)
        
        switch type {
        case .streakIncrease:
            content.title = "🎉 +1 STREAK!"
            content.body = "Lagatar \(currentStreak) din – keep it up!"
            
        case .streakBroken:
            content.title = "😢 Streak Broken!"
            content.body = "Kal se phir start karo. Aaj ek sign seekh lo!"
            
        case .newRecord:
            content.title = "🏆 NEW RECORD!"
            content.body = "\(longestStreak) day streak – tumhara personal best!"
            
        case .dailyReminder:
            content.title = "⏰ Daily Reminder"
            content.body = "Ek sign roz – 5 minute bhi kaafi hai!"
            
        case .motivational:
            let messages = [
                ("💪 Ek aur din!", "Tum kar sakte ho!"),
                ("🌟 Keep shining!", "Aaj bhi sign seekh lo"),
                ("📚 Knowledge is power!", "Continue learning"),
                ("✨ Almost there!", "Few more signs left")
            ]
            let (title, body) = messages.randomElement() ?? ("💪 Keep Going!", "Your streak is on fire!")
            content.title = title
            content.body = body
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Schedule Daily Reminder
    func scheduleDailyReminder(hour: Int = 9, minute: Int = 0) {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let content = UNMutableNotificationContent()
        content.title = "⏰ Daily Reminder"
        content.body = "Ek sign roz – 5 minute bhi kaafi hai!"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Request Notification Permission
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    func daysUntilNextMilestone() -> Int {
        let milestones = [3, 7, 14, 30, 60, 100]
        for milestone in milestones {
            if currentStreak < milestone {
                return milestone - currentStreak
            }
        }
        return 1
    }
    
    func getMilestoneMessage() -> String {
        switch currentStreak {
        case 0: return "🌟 Aaj start kar!"
        case 1: return "🎯 1 din complete!"
        case 3: return "🎉 3 din ka celebration!"
        case 7: return "🔥 1 hafte pura!"
        case 14: return "🏆 2 hafte done!"
        case 30: return "🌟 1 mahina complete!"
        case 60: return "💎 2 mahine ki dedication!"
        case 100: return "👑 100 days legend!"
        default: return "💪 Keep going!"
        }
    }
    
    // MARK: - Reset Streak (for testing)
    func resetStreak() {
        currentStreak = 0
        longestStreak = 0
        lastLearnedDate = nil
        totalSignsLearnedToday = 0
        
        UserDefaults.standard.removeObject(forKey: currentStreakKey)
        UserDefaults.standard.removeObject(forKey: longestStreakKey)
        UserDefaults.standard.removeObject(forKey: lastLearnedDateKey)
        UserDefaults.standard.removeObject(forKey: totalSignsTodayKey)
        
        updateStreakMessage()
    }
    
    // MARK: - Notification Types
    enum NotificationType {
        case streakIncrease
        case streakBroken
        case newRecord
        case dailyReminder
        case motivational
    }
}