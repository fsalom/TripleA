import Foundation

public enum Screen {
    case login
    case home

    var icon: String {
        switch self {
        case .login: "🛂"
        case .home: "🔒"
        }
    }
}
