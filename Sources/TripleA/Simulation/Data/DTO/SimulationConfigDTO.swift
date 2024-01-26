//
//  SimulationConfigDTO.swift
//  
//
//  Created by Pablo Ceacero on 25/1/24.
//

import Foundation

public struct SimulationConfigDTO: Codable {
    let screensEndpoint: [String: [SimulationEndpointDTO]]
    let endpointsAvailability: [SimulationEndpoint.ID: Bool]
    let simulationResponses: [SimulationEndpoint.ID: [SimulationResponseDTO]]
    let simulationResponsesAvailability: [SimulationResponse.ID: Bool]
}
