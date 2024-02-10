//
//  SimulationConfigDTO.swift
//  
//
//  Created by Pablo Ceacero on 25/1/24.
//

import Foundation

public struct SimulationConfigDTO: Codable {
    let endpoints: [SimulationEndpointDTO]
    let endpointsAvailability: [SimulationEndpointDTO.ID: Bool]
    let simulationResponsesForEndpoint: [SimulationEndpointDTO.ID: [SimulationResponseDTO.ID]]
    let simulationResponsesAvailability: [SimulationResponseDTO.ID: Bool]
}
