import WebKit
import SwiftUI

class AtlantisViewModel: ObservableObject {
    @Published var poseidonStatus: PoseidonState = .idle
    let url: URL
    private var webView: WKWebView?
    private var progressObserver: NSKeyValueObservation?
    private var currentProgress: Double = 0.0

    init(url: URL) {
        self.url = url
    }

    // MARK: - Public Methods

    func initializeWebView(_ webView: WKWebView) {
        self.webView = webView
        observeProgress(for: webView)
        loadWebContent()
    }

    func updateConnectionStatus(isOnline: Bool) {
        if isOnline && poseidonStatus == .offline {
            loadWebContent()
        } else if !isOnline {
            setOfflineState()
        }
    }

    // MARK: - Private Methods

    private func loadWebContent() {
        guard let webView = webView else { return }
        let request = URLRequest(url: url, timeoutInterval: 15.0)
        resetProgress()
        webView.load(request)
    }

    private func resetProgress() {
        DispatchQueue.main.async { [weak self] in
            self?.poseidonStatus = .loading(progress: 0.0)
            self?.currentProgress = 0.0
        }
    }

    private func setOfflineState() {
        DispatchQueue.main.async { [weak self] in
            self?.poseidonStatus = .offline
        }
    }

    private func observeProgress(for webView: WKWebView) {
        progressObserver = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.updateProgress(webView.estimatedProgress)
        }
    }

    private func updateProgress(_ progress: Double) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if progress > self.currentProgress {
                self.currentProgress = progress
                self.poseidonStatus = .loading(progress: self.currentProgress)
            }
            if progress >= 1.0 {
                self.poseidonStatus = .completed
            }
        }
    }
}
