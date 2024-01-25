//
//  File.swift
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
}
