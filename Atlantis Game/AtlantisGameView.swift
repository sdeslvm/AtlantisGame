import Foundation
import SwiftUI

class AtlantisColor: UIColor {
    convenience init(rgb: String) {
        let clean = rgb.trimmingCharacters(in: .alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: clean).scanHexInt64(&value)
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}

func launchAtlantis() -> some View {
    let url = createAtlantisURL()
    return createAtlantisScreen(url: url)
}

private func createAtlantisURL() -> URL {
    URL(string: "https://atlantisgame.top/get")!
}

private func createAtlantisScreen(url: URL) -> some View {
    AtlantisScreen(viewModel: .init(url: url))
        .background(Color(AtlantisColor(rgb: "#A51D09")))
}

struct AtlantisEntry: View {
    var body: some View {
        launchAtlantis()
    }
}

#Preview {
    AtlantisEntry()
}
