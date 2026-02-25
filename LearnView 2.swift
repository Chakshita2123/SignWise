import SwiftUI

struct LearnView: View {
    let category: SignCategory

    @State var searchText: String = ""
    @State var scrollOffset: CGFloat = 0

    var signs: [Sign] {
        allSigns.filter { $0.category == category }
    }

    var filteredSigns: [Sign] {
        if searchText.isEmpty {
            return signs
        } else {
            return signs.filter {
                $0.word.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var learnedCount: Int {
        signs.filter { UserDefaults.standard.bool(forKey: $0.id.uuidString) }.count
    }
    
    var categoryColors: [Color] {
        switch category {
        case .greetings: return [Color.appAccent, Color(red: 0.5, green: 0.3, blue: 0.8)]
        case .emergency: return [Color(red: 0.92, green: 0.22, blue: 0.32), Color(red: 1.0, green: 0.5, blue: 0.5)]
        case .family: return [Color(red: 0.95, green: 0.52, blue: 0.08), Color(red: 1.0, green: 0.7, blue: 0.3)]
        case .emotions: return [Color.appAccent2, Color(red: 1.0, green: 0.4, blue: 0.6)]
        case .health: return [Color(red: 0.08, green: 0.72, blue: 0.52), Color(red: 0.2, green: 0.9, blue: 0.6)]
        }
    }

    var body: some View {
        ZStack {
            // MARK: - Parallax Background Layers
            ZStack {
                // Base background
                LinearGradient(
                    colors: [Color.appBG, Color.appBG.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Parallax Layer 1 - Slow movement
                Circle()
                    .fill(categoryColors[0].opacity(0.12))
                    .blur(radius: 80)
                    .offset(y: scrollOffset * 0.2)
                    .frame(width: 280, height: 280)
                    .offset(x: -100, y: -150)
                
                // Parallax Layer 2 - Medium movement
                Circle()
                    .fill(categoryColors[1].opacity(0.08))
                    .blur(radius: 100)
                    .offset(y: scrollOffset * 0.35)
                    .frame(width: 320, height: 320)
                    .offset(x: 80, y: 80)
                
                // Parallax Layer 3 - Accent movement
                RoundedRectangle(cornerRadius: 40)
                    .fill(categoryColors[0].opacity(0.06))
                    .blur(radius: 60)
                    .offset(y: scrollOffset * 0.15)
                    .frame(width: 200, height: 400)
                    .rotationEffect(.degrees(45))
                    .offset(x: -150, y: 300)
            }
            
            // MARK: - Content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    // MARK: - Header with Parallax Effect
                    VStack(spacing: 8) {
                        Text(category.emoji)
                            .font(.system(size: 56))
                            .offset(y: scrollOffset * 0.15)

                        Text(category.rawValue)
                            .font(.system(size: 30, weight: .black))
                            .foregroundColor(.appText)
                            .offset(y: scrollOffset * 0.1)

                        Text("\(learnedCount) of \(signs.count) completed")
                            .font(.system(size: 14))
                            .foregroundColor(.appSubtext)
                            .offset(y: scrollOffset * 0.05)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 6)

                    // MARK: - Search Bar
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.appSubtext)
                            .font(.system(size: 16))

                        TextField("Search signs...", text: $searchText)
                            .font(.system(size: 16))
                            .foregroundColor(.appText)
                            .autocorrectionDisabled()

                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.appSubtext)
                                    .font(.system(size: 16))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color.appCard)
                    .cornerRadius(14)
                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                    .padding(.horizontal)
                    .offset(y: scrollOffset * 0.08)

                    // MARK: - Quiz Button with Parallax
                    NavigationLink(destination: QuizView(category: category)) {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: 18))
                            Text("Take Quiz")
                                .font(.system(size: 16, weight: .bold))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13))
                        }
                        .foregroundColor(.white)
                        .padding(18)
                        .background(
                            LinearGradient(
                                colors: [categoryColors[0], categoryColors[1]],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: categoryColors[0].opacity(0.3), radius: 12, x: 0, y: 6)
                    }
                    .padding(.horizontal)
                    .offset(y: scrollOffset * 0.1)

                    // MARK: - Signs List with Parallax Cards
                    if filteredSigns.isEmpty {
                        VStack(spacing: 12) {
                            Text("🤷")
                                .font(.system(size: 40))
                            Text("No signs found for \"\(searchText)\"")
                                .font(.system(size: 15))
                                .foregroundColor(.appSubtext)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 40)
                    } else {
                        ForEach(Array(filteredSigns.enumerated()), id: \.element.id) { index, sign in
                            NavigationLink(destination: SignDetailView(sign: sign)) {
                                ParallaxSignRow(
                                    sign: sign,
                                    index: index,
                                    scrollOffset: scrollOffset,
                                    categoryColor: categoryColors[0]
                                )
                            }
                            .padding(.horizontal)
                        }
                    }

                    Spacer(minLength: 40)
                }
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).minY)
                    }
                )
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollOffset = value
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Parallax Sign Row
struct ParallaxSignRow: View {
    let sign: Sign
    let index: Int
    let scrollOffset: CGFloat
    let categoryColor: Color

    var isLearned: Bool {
        UserDefaults.standard.bool(forKey: sign.id.uuidString)
    }
    
    var parallaxOffset: CGFloat {
        // Each card moves based on scroll and its index
        return (scrollOffset * 0.2) - (CGFloat(index) * 5)
    }
    
    var scaleEffect: CGFloat {
        // Subtle scale effect for depth
        return 0.95 + (scrollOffset * 0.001)
    }

    var body: some View {
        ZStack {
            // Gradient background with parallax blur
            LinearGradient(
                colors: [
                    Color.appCard,
                    Color.appCard.opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Parallax accent circle
            Circle()
                .fill(categoryColor.opacity(0.08))
                .blur(radius: 30)
                .offset(y: parallaxOffset * 0.3)
                .frame(width: 150, height: 150)
                .offset(x: 80, y: -20)
            
            // Content
            HStack(spacing: 14) {

                // Check Icon
                ZStack {
                    Circle()
                        .fill(isLearned ? Color.green.opacity(0.15) : categoryColor.opacity(0.08))
                        .frame(width: 38, height: 38)
                    Image(systemName: isLearned ? "checkmark" : "hand.raised")
                        .foregroundColor(isLearned ? .green : categoryColor)
                        .font(.system(size: 14, weight: .bold))
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(sign.word)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.appText)

                    Text(sign.handShape)
                        .font(.system(size: 12))
                        .foregroundColor(.appSubtext)
                        .lineLimit(1)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.appSubtext)
                    .font(.system(size: 13))
            }
            .padding(16)
        }
        .cornerRadius(16)
        .shadow(
            color: categoryColor.opacity(0.1),
            radius: 12,
            x: 0,
            y: 4
        )
        .offset(y: parallaxOffset)
        .scaleEffect(scaleEffect, anchor: .center)
    }
}

// MARK: - Scroll Offset Preference Key
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    NavigationView {
        LearnView(category: .greetings)
    }
}