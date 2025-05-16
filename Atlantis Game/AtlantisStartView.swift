import WebKit

class AtlantisNavigator: NSObject, WKNavigationDelegate {
    let stage: AtlantisWebStage
    private var navigationFlag = false

    init(stage: AtlantisWebStage) {
        self.stage = stage
    }

    private func handleNavigationStart() {
        if !navigationFlag { updatePoseidonState(.loading(progress: 0.0)) }
    }

    private func handleNavigationCommit() {
        navigationFlag = false
    }

    private func handleNavigationFinish() {
        updatePoseidonState(.completed)
    }

    private func handleNavigationError(_ error: Error) {
        updatePoseidonState(.failed(error))
    }

    private func updatePoseidonState(_ state: PoseidonState) {
        DispatchQueue.main.async { [weak self] in
            self?.stage.viewModel.poseidonStatus = state
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        handleNavigationStart()
    }

    func webView(_ webView: WKWebView, didCommit _: WKNavigation!) {
        handleNavigationCommit()
    }

    func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
        handleNavigationFinish()
    }

    func webView(_ webView: WKWebView, didFail _: WKNavigation!, withError error: Error) {
        handleNavigationError(error)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError error: Error) {
        handleNavigationError(error)
    }

    func webView(_ webView: WKWebView, decidePolicyFor action: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if action.navigationType == .other && webView.url != nil {
            navigationFlag = true
        }
        decisionHandler(.allow)
    }
}
