import SwiftUI

struct HandBookView: View {
    @State var selectedType: FlashCardType = .alphabet
    @State var currentIndex: Int = 0
    @State var flipped: Bool = false
    
    var cards: [FlashCard] {
        selectedType == .alphabet ? alphabetCards : numberCards
    }
    
    var currentCard: FlashCard {
        cards[currentIndex]
    }
    
    var body: some View {
        ZStack {
            // Using appBG from theme
            Color.appBG.ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                // MARK: - Header
                Text("✋ HandBook")
                    .font(.system(size: 30, weight: .black))
                    .foregroundColor(.appText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                // MARK: - Segment Picker
                HStack(spacing: 0) {
                    ForEach(FlashCardType.allCases, id: \.self) { type in
                        Button {
                            selectedType = type
                            currentIndex = 0
                            flipped = false
                        } label: {
                            Text(type == .alphabet ? "🔤 Alphabets" : "🔢 Numbers")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(selectedType == type ? .white : .appSubtext)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    selectedType == type
                                    ? Color.appAccent
                                    : Color.appCard
                                )
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(4)
                .background(Color.appCard)
                .cornerRadius(14)
                .padding(.horizontal)
                
                // MARK: - Progress
                Text("\(currentIndex + 1) of \(cards.count)")
                    .font(.system(size: 14))
                    .foregroundColor(.appSubtext)
                
                // MARK: - Flashcard
                ZStack {
                    // Back of card (Hand Shape description)
                    if flipped {
                        VStack(spacing: 20) {
                            Text(currentCard.symbol)
                                .font(.system(size: 60, weight: .black))
                                .foregroundColor(.appText)
                            
                            Divider()
                                .background(Color.appAccent.opacity(0.2))
                            
                            Text("Hand Shape")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.appAccent)
                            
                            Text(currentCard.handShape)
                                .font(.system(size: 18))
                                .foregroundColor(.appText)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Text("Tap to flip back")
                                .font(.system(size: 12))
                                .foregroundColor(.appSubtext)
                        }
                        .padding(30)
                        .frame(maxWidth: .infinity)
                        .frame(height: 320)
                        .background(Color.appCard)
                        .cornerRadius(28)
                        .padding(.horizontal)
                        .shadow(color: Color.appAccent.opacity(0.08), radius: 12, x: 0, y: 4)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        
                    } else {
                        // Front of card (Image + Symbol)
                        VStack(spacing: 16) {
                            Text(currentCard.symbol)
                                .font(.system(size: 80, weight: .black))
                                .foregroundColor(.white)
                            
                            SignImage(imageName: currentCard.imageName, size: 120)
                            
                            Text("Tap to see hand shape")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(30)
                        .frame(maxWidth: .infinity)
                        .frame(height: 320)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color.appAccent,
                                    Color.appAccent2
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(28)
                        .padding(.horizontal)
                        .shadow(color: Color.appAccent.opacity(0.15), radius: 16, x: 0, y: 6)
                    }
                }
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        flipped.toggle()
                    }
                }
                .rotation3DEffect(
                    .degrees(flipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: flipped)
                
                // MARK: - Navigation Buttons
                HStack(spacing: 20) {
                    
                    // Previous
                    Button {
                        if currentIndex > 0 {
                            currentIndex -= 1
                            flipped = false
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                            Text("Prev")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(currentIndex == 0 ? .appSubtext : .appText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.appCard)
                        .cornerRadius(14)
                        .opacity(currentIndex == 0 ? 0.5 : 1.0)
                    }
                    .disabled(currentIndex == 0)
                    
                    // Next
                    Button {
                        if currentIndex < cards.count - 1 {
                            currentIndex += 1
                            flipped = false
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Text("Next")
                            Image(systemName: "chevron.right")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(currentIndex == cards.count - 1 ? .appSubtext : .appText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.appCard)
                        .cornerRadius(14)
                        .opacity(currentIndex == cards.count - 1 ? 0.5 : 1.0)
                    }
                    .disabled(currentIndex == cards.count - 1)
                }
                .padding(.horizontal)
                
                // MARK: - Dots Indicator
                HStack(spacing: 6) {
                    ForEach(0..<min(cards.count, 10), id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex % 10
                                  ? Color.appAccent
                                  : Color.appSubtext.opacity(0.3))
                            .frame(width: index == currentIndex % 10 ? 10 : 6,
                                   height: index == currentIndex % 10 ? 10 : 6)
                    }
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    HandBookView()
}