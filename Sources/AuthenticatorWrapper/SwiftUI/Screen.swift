import Foundation

public enum Screen {
    case login
    case home
    case loading

    var icon: String {
        switch self {
        case .login: "🛂"
        case .home: "🔒"
        case .loading: "⏳"
        }
    }
}
