//
//  SimulationConfig.swift
//  
//
//  Created by Pablo Ceacero on 26/1/24.
//

import Foundation

public struct SimulationConfig {
    var screensEndpoint: [String: [SimulationEndpoint]]
    var endpointsAvailability: [SimulationEndpoint.ID: Bool]
    var simulationResponses: [SimulationEndpoint.ID: [SimulationResponse]]
    var simulationResponsesAvailability: [SimulationResponse.ID: Bool]
}
