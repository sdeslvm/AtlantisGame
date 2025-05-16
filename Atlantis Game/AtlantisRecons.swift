import Foundation
import SwiftUI
import WebKit

enum PoseidonState: Equatable {
    case idle
    case loading(progress: Double)
    case completed
    case failed(Error)
    case offline

    static func == (lhs: PoseidonState, rhs: PoseidonState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.completed, .completed), (.offline, .offline):
            return true
        case (.loading(let lp), .loading(let rp)):
            return lp == rp
        case (.failed, .failed):
            return true
        default:
            return false
        }
    }
}

