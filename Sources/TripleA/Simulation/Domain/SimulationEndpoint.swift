//
//  SimulationEndpoint.swift
//  
//
//  Created by Pablo Ceacero on 16/1/24.
//

import UIKit

public struct SimulationEndpoint: Identifiable {
    public let id: String
    let displayName: AttributedString
    let responses: [SimulationResponse]

    public init(endpoint: Endpoint, responses: [SimulationResponse]) {
        self.id = "\(endpoint.httpMethod.rawValue)\(endpoint.path)".uppercased()
        self.displayName = SimulationEndpoint.customizeDisplayName(basedOn: endpoint)
        self.responses = responses
    }

    public init(id: String, displayName: AttributedString, responses: [SimulationResponse]) {
        self.id = id
        self.displayName = displayName
        self.responses = responses
    }
}

// MARK: - Equatable

extension SimulationEndpoint: Equatable {
    public static func == (lhs: SimulationEndpoint, rhs: SimulationEndpoint) -> Bool {
        lhs.id == rhs.id &&
        lhs.displayName == rhs.displayName &&
        lhs.responses == rhs.responses
    }
}

private extension SimulationEndpoint {
    static func customizeDisplayName(basedOn endpoint: Endpoint) -> AttributedString {
        let textToColor = endpoint.httpMethod.rawValue.uppercased()
        let completeText = "\(endpoint.httpMethod) /\(endpoint.path)".uppercased()
        let range = (completeText as NSString).range(of: textToColor)
        let color = endpoint.httpMethod.color

        let mutableAttributedString = NSMutableAttributedString.init(string: completeText)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                             value: color,
                                             range: range)
        return AttributedString(mutableAttributedString)
    }
}

fileprivate extension Endpoint.HTTPMethod {
    var color: UIColor {
        switch self {
        case .get: return .systemGreen
        case .delete: return .systemRed
        default: return .orange
        }
    }
}
