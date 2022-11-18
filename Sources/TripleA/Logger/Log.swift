import Foundation

enum LogType {
    case error
    case info
    case warning
    case debug
    case verbose
}

public enum LogFormat {
    case full
    case short
    case requestOnly
    case none
}

struct Log {
    static func time() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
    
    static func this(_ message: String, file: String = #file, function: String = #function, line: Int = #line, type: LogType = .debug) {
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
    
    static func thisCall(_ call: URLRequest, format: LogFormat = .full) {
        let url     = call.url?.absoluteString ?? ""
        let headers = call.allHTTPHeaderFields ?? [:]
        let method  = call.httpMethod ?? ""
        let params  = String(data: call.httpBody ?? Data(), encoding: .utf8)

        switch format {
        case .full, .requestOnly:
            print("------------------------------------------")
            print("➡️ \(method) \(url) ")
            print("HEADERS: \(headers)")
            print("PARAMETERS: \(params ?? "")")
            print("------------------------------------------")
        case .short:
            print("------------------------------------------")
            print("➡️ \(method) \(url) ")
            print("------------------------------------------")
        case .none:
            break
        }

    }
    
    static func thisResponse(_ response: HTTPURLResponse, data: Data, format: LogFormat = .full) {
        let code = response.statusCode
        let url  = response.url?.absoluteString ?? ""
        let icon  = (200..<300).contains(code) ? "✅" : "❌"
        switch format {
        case .full:
            print("------------------------------------------")
            print("\(icon) 🔽 [\(code)] \(url)")
            print("\(data.prettyPrintedJSONString ?? "")")
            print("\(icon) 🔼 [\(code)] \(url)")
            print("------------------------------------------")
        case .short:
            print("------------------------------------------")
            print("\(icon) ⬅️ [\(code)] \(url)")
            print("------------------------------------------")
        case .requestOnly, .none:
            break
        }
    }
    
    static func thisError(_ error : Error) {
        print("🤬 ERROR: \(error.localizedDescription)")
        print("🤖 RAW VALUE: \(error)")
        print("------------------------------------------")
    }
    
    static func thisError(_ error : NetworkError) {
        print("🤬 ERROR: \(error.localizedDescription)")
        print("🤖 RAW VALUE: \(error)")
        print("------------------------------------------")
    }

    static func this(_ value : String) {
        print("******************************************")
        print("💾 \(value)")
        print("******************************************")
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}
