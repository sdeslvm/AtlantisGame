import SwiftUI

extension View {
    func atlantisProgressBar(_ value: Double) -> some View {
        self.modifier(AtlantisProgressModifier(progress: value))
    }
}

struct AtlantisProgressModifier: ViewModifier {
    var progress: Double

    func body(content: Content) -> some View {
        ZStack {
            content // Основной контент остается внизу (например, фон)

            // Прозрачный слой сверху для затемнения/фокусировки на прогрессе
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack {
                Spacer()
                Text("Loading")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)

                LinearProgressView(progress: progress)
                    .frame(height: 12)
                    .padding(.horizontal, 40)

                Text("\(Int(progress * 100))%")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.top, 10)

                Spacer()
            }
        }
    }
}

struct LinearProgressView: View {
    var progress: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.2)
                    .foregroundColor(.white)

                Rectangle()
                    .frame(width: max(0, CGFloat(min(max(progress, 0), 1)) * geometry.size.width), height: geometry.size.height)
                    .foregroundColor(.red)
                    .animation(.easeOut(duration: 0.3), value: progress)
            }
            .cornerRadius(6)
        }
    }
}

#Preview {
    Text("Preview").atlantisProgressBar(0.2)
}
