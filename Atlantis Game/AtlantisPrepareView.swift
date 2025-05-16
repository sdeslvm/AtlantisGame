import WebKit
import SwiftUI
import Foundation

struct AtlantisWebStage: UIViewRepresentable {
    @ObservedObject var viewModel: AtlantisViewModel
    typealias Coordinator = AtlantisNavigator

    // MARK: - UIViewRepresentable Methods

    func makeCoordinator() -> AtlantisNavigator {
        AtlantisNavigator(stage: self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = configureWebView(context: context)
        viewModel.initializeWebView(webView)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        clearWebData()
    }

    // MARK: - Private Methods

    private func configureWebView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isOpaque = false
        webView.backgroundColor = AtlantisColor(rgb: "#141f2b")
        clearWebData()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    private func clearWebData() {
        let dataTypes: Set<String> = [
            WKWebsiteDataTypeLocalStorage,
            WKWebsiteDataTypeCookies,
            WKWebsiteDataTypeDiskCache,
            WKWebsiteDataTypeMemoryCache
        ]
        WKWebsiteDataStore.default().removeData(ofTypes: dataTypes, modifiedSince: Date.distantPast) {}
    }
}
