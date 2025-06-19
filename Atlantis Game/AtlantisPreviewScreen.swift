import SwiftUI
import Foundation

struct AtlantisEntryScreen: View {
    @StateObject private var loader: AtlantisWebLoader

    init(loader: AtlantisWebLoader) {
        _loader = StateObject(wrappedValue: loader)
    }

    var body: some View {
        ZStack {
            AtlantisWebViewBox(loader: loader)
                .opacity(loader.state == .finished ? 1 : 0.5)
            switch loader.state {
            case .progressing(let percent):
                AtlantisProgressIndicator(value: percent)
            case .failure(let err):
                AtlantisErrorIndicator(err: err)
            case .noConnection:
                AtlantisOfflineIndicator()
            default:
                EmptyView()
            }
        }
    }
}

private struct AtlantisProgressIndicator: View {
    let value: Double
    var body: some View {
        GeometryReader { geo in
//            atlantisLoadingOverlay(value)
//                .frame(width: geo.size.width, height: geo.size.height)
//                .background(Color.black)
        }
    }
}

private struct AtlantisErrorIndicator: View {
    let err: String
    var body: some View {
        Text("Ошибка: \(err)").foregroundColor(.red)
    }
}

private struct AtlantisOfflineIndicator: View {
    var body: some View {
        Text("Нет соединения").foregroundColor(.gray)
    }
}
