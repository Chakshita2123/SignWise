import SwiftUI

struct ContentView: View {
    @State var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // Home Tab
            HomeScreen()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            // Progress Tab
            ProgressScreen()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Progress")
                }
                .tag(1)
        }
        .accentColor(Color(red: 0.4, green: 0.6, blue: 1.0))
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.12, alpha: 1)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

// MARK: - Home Screen
struct HomeScreen: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.05, green: 0.05, blue: 0.12)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 28) {
                        
                        // Header
                        VStack(spacing: 8) {
                            Text("✋")
                                .font(.system(size: 56))
                            Text("SignWise")
                                .font(.system(size: 38, weight: .black))
                                .foregroundColor(.white)
                            Text("Bridge the silence. Learn to sign.")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white.opacity(0.5))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 50)
                        
                        // Progress Banner
                        ProgressBanner()
                            .padding(.horizontal)
                        
                        // Categories
                        VStack(alignment: .leading, spacing: 14) {
                            Text("CATEGORIES")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white.opacity(0.4))
                                .padding(.horizontal)
                            
                            ForEach(SignCategory.allCases, id: \.self) { category in
                                NavigationLink(destination: LearnView(category: category)) {
                                    CategoryCard(category: category)
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Progress Screen
struct ProgressScreen: View {
    
    var totalLearned: Int {
        allSigns.filter { UserDefaults.standard.bool(forKey: $0.id.uuidString) }.count
    }
    
    var percentage: Int {
        Int(Double(totalLearned) / 50.0 * 100)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.05, green: 0.05, blue: 0.12)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 28) {
                        
                        // Title
                        Text("Your Progress")
                            .font(.system(size: 30, weight: .black))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top, 20)
                        
                        // Big Circle
                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.1), lineWidth: 16)
                            Circle()
                                .trim(from: 0, to: CGFloat(percentage) / 100)
                                .stroke(
                                    LinearGradient(
                                        colors: [Color(red: 0.4, green: 0.6, blue: 1.0), Color(red: 0.6, green: 0.4, blue: 1.0)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    style: StrokeStyle(lineWidth: 16, lineCap: .round)
                                )
                                .rotationEffect(.degrees(-90))
                            
                            VStack(spacing: 4) {
                                Text("\(totalLearned)")
                                    .font(.system(size: 52, weight: .black))
                                    .foregroundColor(.white)
                                Text("of 50 signs")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.5))
                                Text("\(percentage)% done")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(Color(red: 0.4, green: 0.6, blue: 1.0))
                            }
                        }
                        .frame(width: 200, height: 200)
                        
                        // Per Category Breakdown
                        VStack(spacing: 12) {
                            Text("BY CATEGORY")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white.opacity(0.4))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            ForEach(SignCategory.allCases, id: \.self) { category in
                                CategoryProgressRow(category: category)
                                    .padding(.horizontal)
                            }
                        }
                        
                        // Motivational Message
                        if totalLearned == 50 {
                            Text("🏆 You've learned all 50 signs!")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                                .padding(20)
                                .background(Color.white.opacity(0.07))
                                .cornerRadius(16)
                                .padding(.horizontal)
                        } else if totalLearned == 0 {
                            Text("👋 Start learning your first sign!")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                                .padding(20)
                                .background(Color.white.opacity(0.07))
                                .cornerRadius(16)
                                .padding(.horizontal)
                        } else {
                            Text("💪 \(50 - totalLearned) signs left — keep going!")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                                .padding(20)
                                .background(Color.white.opacity(0.07))
                                .cornerRadius(16)
                                .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Category Progress Row
struct CategoryProgressRow: View {
    let category: SignCategory
    
    var total: Int { allSigns.filter { $0.category == category }.count }
    var learned: Int {
        allSigns.filter { $0.category == category }
            .filter { UserDefaults.standard.bool(forKey: $0.id.uuidString) }
            .count
    }
    var progress: Double { Double(learned) / Double(total) }
    
    var cardColor: Color {
        switch category {
        case .greetings: return Color(red: 0.2, green: 0.5, blue: 1.0)
        case .numbers:   return Color(red: 0.6, green: 0.3, blue: 1.0)
        case .emergency: return Color(red: 1.0, green: 0.3, blue: 0.3)
        case .family:    return Color(red: 1.0, green: 0.6, blue: 0.1)
        case .emotions:  return Color(red: 0.2, green: 0.8, blue: 0.6)
        case .health:    return Color(red: 0.3, green: 0.9, blue: 0.4)
        }
    }
    
    var body: some View {
        HStack(spacing: 14) {
            Text(category.emoji)
                .font(.system(size: 28))
                .frame(width: 48, height: 48)
                .background(cardColor.opacity(0.15))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(category.rawValue)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(learned)/\(total)")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.5))
                }
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(cardColor)
                        .frame(width: (UIScreen.main.bounds.width - 80) * progress, height: 6)
                }
            }
        }
        .padding(14)
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
}

// MARK: - Progress Banner (for Home)
struct ProgressBanner: View {
    var totalLearned: Int {
        allSigns.filter { UserDefaults.standard.bool(forKey: $0.id.uuidString) }.count
    }
    var progress: Double { Double(totalLearned) / 50.0 }
    
    var body: some View {
        VStack(spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Progress")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
                    Text("\(totalLearned) of 50 signs")
                        .font(.system(size: 22, weight: .black))
                        .foregroundColor(.white)
                }
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 32, weight: .black))
                    .foregroundColor(.white)
            }
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 10)
                RoundedRectangle(cornerRadius: 6)
                    .fill(LinearGradient(
                        colors: [Color(red: 0.4, green: 0.6, blue: 1.0), Color(red: 0.6, green: 0.4, blue: 1.0)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(width: UIScreen.main.bounds.width * 0.85 * progress, height: 10)
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.07))
        .cornerRadius(20)
    }
}

// MARK: - Category Card (for Home)
struct CategoryCard: View {
    let category: SignCategory
    
    var totalCount: Int { allSigns.filter { $0.category == category }.count }
    var learnedCount: Int {
        allSigns.filter { $0.category == category }
            .filter { UserDefaults.standard.bool(forKey: $0.id.uuidString) }
            .count
    }
    var progress: Double { Double(learnedCount) / Double(totalCount) }
    
    var cardColor: (Color, Color) {
        switch category {
        case .greetings: return (Color(red: 0.2, green: 0.5, blue: 1.0), Color(red: 0.1, green: 0.3, blue: 0.8))
        case .numbers:   return (Color(red: 0.6, green: 0.3, blue: 1.0), Color(red: 0.4, green: 0.1, blue: 0.8))
        case .emergency: return (Color(red: 1.0, green: 0.3, blue: 0.3), Color(red: 0.8, green: 0.1, blue: 0.1))
        case .family:    return (Color(red: 1.0, green: 0.6, blue: 0.1), Color(red: 0.9, green: 0.4, blue: 0.0))
        case .emotions:  return (Color(red: 0.2, green: 0.8, blue: 0.6), Color(red: 0.0, green: 0.6, blue: 0.4))
        case .health:    return (Color(red: 0.3, green: 0.9, blue: 0.4), Color(red: 0.1, green: 0.7, blue: 0.2))
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Text(category.emoji)
                .font(.system(size: 30))
                .frame(width: 58, height: 58)
                .background(Color.white.opacity(0.15))
                .cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(category.rawValue)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                Text("\(learnedCount)/\(totalCount) learned")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.7))
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 5)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white)
                        .frame(width: 160 * progress, height: 5)
                }
                .frame(width: 160)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.6))
                .font(.system(size: 14, weight: .semibold))
        }
        .padding(18)
        .background(LinearGradient(
            colors: [cardColor.0, cardColor.1],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
        .cornerRadius(20)
    }
}

#Preview {
    ContentView()
}
