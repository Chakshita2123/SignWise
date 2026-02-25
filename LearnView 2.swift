import SwiftUI

struct LearnView: View {
    let category: SignCategory

    @State var searchText: String = ""

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

    var body: some View {
        ZStack {
            Color.appBG.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    // MARK: - Header
                    VStack(spacing: 8) {
                        Text(category.emoji)
                            .font(.system(size: 56))

                        Text(category.rawValue)
                            .font(.system(size: 30, weight: .black))
                            .foregroundColor(.appText)

                        Text("\(learnedCount) of \(signs.count) completed")
                            .font(.system(size: 14))
                            .foregroundColor(.appSubtext)
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

                    // MARK: - Quiz Button
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
                                colors: [.appAccent, .appAccent2],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)

                    // MARK: - Signs List
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
                        ForEach(filteredSigns) { sign in
                            NavigationLink(destination: SignDetailView(sign: sign)) {
                                SignRow(sign: sign)
                            }
                            .padding(.horizontal)
                        }
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
                    .fill(isLearned ? Color.green.opacity(0.15) : Color.appAccent.opacity(0.08))
                    .frame(width: 38, height: 38)
                Image(systemName: isLearned ? "checkmark" : "hand.raised")
                    .foregroundColor(isLearned ? .green : .appAccent)
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
        .background(Color.appCard)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}

#Preview {
    NavigationView {
        LearnView(category: .greetings)
    }
}