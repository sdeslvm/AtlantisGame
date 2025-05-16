import SwiftUI

struct AtlantisScreen: View {
    @StateObject var viewModel: AtlantisViewModel

    init(viewModel: AtlantisViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            createWebStage()
            createOverlayContent()
        }
    }

    // MARK: - Private Methods

    private func createWebStage() -> some View {
        AtlantisWebStage(viewModel: viewModel)
            .opacity(viewModel.poseidonStatus == .completed ? 1 : 0.3)
    }

    private func createOverlayContent() -> some View {
        Group {
            switch viewModel.poseidonStatus {
            case .loading(let progress):
                Color.clear.atlantisProgressBar(progress)
            case .failed(let error):
                createErrorView(error)
            case .offline:
                createOfflineView()
            default:
                EmptyView()
            }
        }
    }

    private func createErrorView(_ error: Error) -> some View {
        Text("Error: \(error.localizedDescription)")
            .foregroundColor(.pink)
    }

    private func createOfflineView() -> some View {
        Text("Offline")
            .foregroundColor(.gray)
    }
}
