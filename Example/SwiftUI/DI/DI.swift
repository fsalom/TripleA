import Foundation
import TripleA

class DI {
    static var shared = DI()

    var network = Network(baseURL: "")
}
