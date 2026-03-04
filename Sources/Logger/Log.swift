import Foundation

public enum LogType {
    case error
    case info
    case warning
    case debug
    case verbose
}

public enum LogFormat {
    case full
    case custom(characters: Int)
    case short
    case requestOnly
    case none
}

public struct Log {
    static func time() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
    
    public static func this(_ message: String, file: String = #file, function: String = #function, line: Int = #line, type: LogType = .debug) {
        let path = file.split(separator: "/")
        let file = path.last?.split(separator: ".")
        
        var icon = "📝"
        switch type {
        case .debug:   icon = "💚 DEBUG"
        case .info:    icon = "💙 INFO"
        case .warning: icon = "💛 WARNING"
        case .error:   icon = "❤️ ERROR"
        case .verbose: icon = "💜 VERBOSE"
        }
        
        print("\(self.time()) \(icon) \(file?.first ?? "").\(function):\(line) - \n\n\t\(message)\n")
    }
    
    public static func thisCall(_ call: URLRequest, format: LogFormat = .full) {
        let url     = call.url?.absoluteString ?? ""
        let headers = call.allHTTPHeaderFields ?? [:]
        let method  = call.httpMethod ?? ""
        let params  = String(data: call.httpBody ?? Data(), encoding: .utf8)

        switch format {
        case .full, .requestOnly, .custom(_):
            print("------------------------------------------")
            print("☎️ ➡️ \(method) \(url) ")
            print("HEADERS: \(headers)")
            print("PARAMETERS: \(params ?? "")")
            print("------------------------------------------")
        case .short:
            print("☎️ ➡️ \(method) \(url) ")
        case .none:
            break
        }
    }
    
    public static func thisResponse(_ response: HTTPURLResponse, data: Data, format: LogFormat = .full) {
        let code = response.statusCode
        let url  = response.url?.absoluteString ?? ""
        let icon  = (200..<300).contains(code) ? "✅" : "❌"
        let json: String = (data.prettyPrintedJSONString ?? "") as String
        switch format {
        case .full:
            print("------------------------------------------")
            print("\(icon) 🔽 [\(code)] \(url)")
            print("\(json)")
            print("\(icon) 🔼 [\(code)] \(url)")
            print("------------------------------------------")
        case .custom(let characters):
            print("------------------------------------------")
            print("\(icon) 🔽 [\(code)] \(url)")
            print("\(json.prefix(characters))")
            print("\(icon) 🔼 [\(code)] \(url)")
            print("------------------------------------------")
        case .short:
            print("\(icon) ⬅️ [\(code)] \(url)")
        default:
            break
        }
    }

    public static func thisURL(_ url: URL, format: LogFormat = .full) {
        let url = url.absoluteString

        switch format {
        default:
            print("📡 ➡️ \(url) ")
        }
    }
    
    public static func thisError(_ error : Error) {
        print("🤬 ERROR: \(error.localizedDescription)")
        print("🤖 RAW VALUE: \(error)")
        print("------------------------------------------")
    }
    
    public static func thisError(_ error : NetworkError) {
        print("🤬 ERROR: \(error.localizedDescription)")
        print("🤖 RAW VALUE: \(error)")
        print("------------------------------------------")
    }

    public static func this(_ value : String, format: LogFormat = .full) {
        print("🔒 💾 \(value)")
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}
