//
//  SimulationEndpointDTO.swift
//  
//
//  Created by Pablo Ceacero on 26/1/24.
//

import Foundation

struct SimulationEndpointDTO: Identifiable, Codable {
    let id: String
    let displayName: AttributedString
    let responses: [SimulationResponseDTO]
}
