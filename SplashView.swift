import SwiftUI

struct SplashView: View {
    @State var showMain: Bool = false

    var body: some View {
        if showMain {
            ContentView()
        } else {
            OnboardingView(showMain: $showMain)
        }
    }
}

struct OnboardingView: View {
    @Binding var showMain: Bool

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(red: 0.32, green: 0.18, blue: 0.72),
                    Color(red: 0.85, green: 0.25, blue: 0.55)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {

                // 100% Offline Badge
                HStack {
                    Spacer()
                    HStack(spacing: 6) {
                        Image(systemName: "wifi.slash")
                            .font(.system(size: 12))
                        Text("100% Offline")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(20)
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)

                Spacer()

                // Logo Circle
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.12))
                        .frame(width: 210, height: 210)

                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 165, height: 165)

                    Text("🤟")
                        .font(.system(size: 80))
                }
                .padding(.bottom, 36)

                // App Name
                Text("SignWise")
                    .font(.system(size: 44, weight: .black))
                    .foregroundColor(.white)

                // Underline
                Rectangle()
                    .fill(Color.white.opacity(0.4))
                    .frame(width: 60, height: 3)
                    .cornerRadius(2)
                    .padding(.top, 8)
                    .padding(.bottom, 36)

                // Quote
                Text("\"Because communication is\na right,\nnot a privilege.\"")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)

                Spacer()

                // Get Started Button
                Button {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        showMain = true
                    }
                } label: {
                    Text("Get Started")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(red: 0.32, green: 0.18, blue: 0.72))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.white)
                        .cornerRadius(16)
                        .padding(.horizontal, 40)
                }

                Text("Learn at your own pace. No internet needed.")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.top, 14)
                    .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    SplashView()
}