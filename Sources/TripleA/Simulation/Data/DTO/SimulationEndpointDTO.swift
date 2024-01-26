//
//  SimulationEndpointDTO.swift
//  
//
//  Created by Pablo Ceacero on 26/1/24.
//

import Foundation

struct SimulationEndpointDTO: Codable {
    let id: String
    let displayName: String
    let responses: [SimulationResponseDTO]
}
