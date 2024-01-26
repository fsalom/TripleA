//
//  SimulationEndpoint.swift
//  
//
//  Created by Pablo Ceacero on 16/1/24.
//

import UIKit

public struct SimulationEndpoint: Identifiable {
    public let id: String
    let displayName: String
    let responses: [SimulationResponse]

    public init(endpoint: Endpoint, responses: [SimulationResponse]) {
        self.id = "\(endpoint.httpMethod.rawValue)\(endpoint.path)".uppercased()
        self.displayName = "\(endpoint.httpMethod) \(endpoint.path)".uppercased()
        self.responses = responses
    }

    public init(id: String, displayName: String, responses: [SimulationResponse]) {
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
