import SwiftUI

// MARK: - Theme Colors
extension Color {
    static let appBG       = Color(red: 0.97, green: 0.96, blue: 0.93)   // warm cream
    static let appCard     = Color(red: 1.0, green: 0.99, blue: 0.97)    // soft white
    static let appAccent   = Color(red: 0.32, green: 0.18, blue: 0.72)   // deep violet
    static let appAccent2  = Color(red: 0.85, green: 0.25, blue: 0.55)   // hot pink
    static let appText     = Color(red: 0.1, green: 0.08, blue: 0.15)    // near black
    static let appSubtext  = Color(red: 0.45, green: 0.42, blue: 0.52)   // muted purple gray
}

struct ContentView: View {
    @State var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {

            HomeScreen()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

            HandBookView()
                .tabItem {
                    Image(systemName: "hand.raised.fill")
                    Text("HandBook")
                }
                .tag(1)

            ProgressScreen()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Progress")
                }
                .tag(2)
        }
        .accentColor(.appAccent)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 0.97, green: 0.96, blue: 0.93, alpha: 1)
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
                Color.appBG.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 28) {

                        // Header
                        VStack(spacing: 6) {
                            Text("✋")
                                .font(.system(size: 52))

                            Text("SignWise")
                                .font(.system(size: 36, weight: .black))
                                .foregroundColor(.appText)

                            Text("Bridge the silence. Learn to sign.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.appSubtext)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 50)

                        // Progress Banner
                        ProgressBanner()
                            .padding(.horizontal)

                        // Categories
                        VStack(alignment: .leading, spacing: 14) {
                            Text("CATEGORIES")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.appSubtext)
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

// MARK: - Progress Banner
struct ProgressBanner: View {
    var totalSigns: Int { allSigns.count }
    var totalLearned: Int {
        allSigns.filter { UserDefaults.standard.bool(forKey: $0.id.uuidString) }.count
    }
    var progress: Double { Double(totalLearned) / Double(totalSigns) }

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Progress")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.appSubtext)
                    Text("\(totalLearned) of \(totalSigns) signs")
                        .font(.system(size: 22, weight: .black))
                        .foregroundColor(.appText)
                }
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 32, weight: .black))
                    .foregroundColor(.appAccent)
            }

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.appAccent.opacity(0.12))
                    .frame(height: 10)
                RoundedRectangle(cornerRadius: 6)
                    .fill(LinearGradient(
                        colors: [.appAccent, .appAccent2],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(width: UIScreen.main.bounds.width * 0.85 * progress, height: 10)
            }
        }
        .padding(20)
        .background(Color.appCard)
        .cornerRadius(20)
        .shadow(color: Color.appAccent.opacity(0.08), radius: 12, x: 0, y: 4)
    }
}

// MARK: - Category Card
struct CategoryCard: View {
    let category: SignCategory

    var totalCount: Int { allSigns.filter { $0.category == category }.count }
    var learnedCount: Int {
        allSigns.filter { $0.category == category }
            .filter { UserDefaults.standard.bool(forKey: $0.id.uuidString) }
            .count
    }
    var progress: Double { Double(learnedCount) / Double(totalCount) }

    var accentColor: Color {
        switch category {
        case .greetings: return Color(red: 0.32, green: 0.18, blue: 0.72)
        case .emergency: return Color(red: 0.92, green: 0.22, blue: 0.32)
        case .family:    return Color(red: 0.95, green: 0.52, blue: 0.08)
        case .emotions:  return Color(red: 0.85, green: 0.25, blue: 0.55)
        case .health:    return Color(red: 0.08, green: 0.72, blue: 0.52)
        }
    }

    var body: some View {
        HStack(spacing: 16) {

            // Emoji box
            Text(category.emoji)
                .font(.system(size: 28))
                .frame(width: 56, height: 56)
                .background(accentColor.opacity(0.12))
                .cornerRadius(16)

            VStack(alignment: .leading, spacing: 6) {
                Text(category.rawValue)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.appText)

                Text("\(learnedCount)/\(totalCount) learned")
                    .font(.system(size: 13))
                    .foregroundColor(.appSubtext)

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(accentColor.opacity(0.12))
                        .frame(height: 5)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(accentColor)
                        .frame(width: 160 * progress, height: 5)
                }
                .frame(width: 160)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.appSubtext)
                .font(.system(size: 13, weight: .semibold))
        }
        .padding(18)
        .background(Color.appCard)
        .cornerRadius(20)
        .shadow(color: accentColor.opacity(0.08), radius: 8, x: 0, y: 3)
    }
}

// MARK: - Progress Screen
struct ProgressScreen: View {
    var totalSigns: Int { allSigns.count }
    var totalLearned: Int {
        allSigns.filter { UserDefaults.standard.bool(forKey: $0.id.uuidString) }.count
    }
    var percentage: Int { Int(Double(totalLearned) / Double(totalSigns) * 100) }

    var body: some View {
        NavigationView {
            ZStack {
                Color.appBG.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 28) {

                        Text("Your Progress")
                            .font(.system(size: 30, weight: .black))
                            .foregroundColor(.appText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top, 20)

                        // Big Circle
                        ZStack {
                            Circle()
                                .stroke(Color.appAccent.opacity(0.1), lineWidth: 16)
                            Circle()
                                .trim(from: 0, to: CGFloat(percentage) / 100)
                                .stroke(
                                    LinearGradient(
                                        colors: [.appAccent, .appAccent2],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    style: StrokeStyle(lineWidth: 16, lineCap: .round)
                                )
                                .rotationEffect(.degrees(-90))

                            VStack(spacing: 4) {
                                Text("\(totalLearned)")
                                    .font(.system(size: 52, weight: .black))
                                    .foregroundColor(.appText)
                                Text("of \(totalSigns) signs")
                                    .font(.system(size: 14))
                                    .foregroundColor(.appSubtext)
                                Text("\(percentage)% done")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.appAccent)
                            }
                        }
                        .frame(width: 200, height: 200)

                        // Category Breakdown
                        VStack(spacing: 12) {
                            Text("BY CATEGORY")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.appSubtext)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)

                            ForEach(SignCategory.allCases, id: \.self) { category in
                                CategoryProgressRow(category: category)
                                    .padding(.horizontal)
                            }
                        }

                        // Motivational Message
                        Group {
                            if totalLearned == totalSigns {
                                Text("🏆 You've learned all \(totalSigns) signs!")
                            } else if totalLearned == 0 {
                                Text("👋 Start learning your first sign!")
                            } else {
                                Text("💪 \(totalSigns - totalLearned) signs left — keep going!")
                            }
                        }
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.appAccent)
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color.appAccent.opacity(0.08))
                        .cornerRadius(16)
                        .padding(.horizontal)

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

    var accentColor: Color {
        switch category {
        case .greetings: return Color(red: 0.32, green: 0.18, blue: 0.72)
        case .emergency: return Color(red: 0.92, green: 0.22, blue: 0.32)
        case .family:    return Color(red: 0.95, green: 0.52, blue: 0.08)
        case .emotions:  return Color(red: 0.85, green: 0.25, blue: 0.55)
        case .health:    return Color(red: 0.08, green: 0.72, blue: 0.52)
        }
    }

    var body: some View {
        HStack(spacing: 14) {
            Text(category.emoji)
                .font(.system(size: 26))
                .frame(width: 48, height: 48)
                .background(accentColor.opacity(0.1))
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(category.rawValue)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.appText)
                    Spacer()
                    Text("\(learned)/\(total)")
                        .font(.system(size: 13))
                        .foregroundColor(.appSubtext)
                }

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(accentColor.opacity(0.1))
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(accentColor)
                        .frame(width: (UIScreen.main.bounds.width - 110) * progress, height: 6)
                }
            }
        }
        .padding(14)
        .background(Color.appCard)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}

#Preview {
    ContentView()
}