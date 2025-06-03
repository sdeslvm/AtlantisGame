import SwiftUI

struct AtlantisAbout: View {
    @State private var waveOffset = Angle(degrees: 0)

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 40) {
                Text("ATLANTIS")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundStyle(.white)
                    .shadow(radius: 10)

                Text("A dimension beyond the oceans.\nWhere echoes of ancient minds drift with the current.\nWelcome to the unknown.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.9))
                    .font(.title3)
                    .padding()

               

                Spacer()

                HStack(spacing: 30) {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay(Text("∞").foregroundColor(.white).font(.title))

                    VStack {
                        Text("Depth Level")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        Text("7.3 km")
                            .font(.title2)
                            .foregroundColor(.cyan)
                    }

                    Image(systemName: "sparkles")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .foregroundColor(.mint)
                }

                Spacer()
            }
            .padding()
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 6).repeatForever(autoreverses: false)) {
                waveOffset = Angle(degrees: 360)
            }
        }
    }
}



#Preview {
    AtlantisAbout()
}
