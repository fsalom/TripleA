//
//  SimulationResponseDTO.swift
//  
//
//  Created by Pablo Ceacero on 26/1/24.
//

import Foundation

struct SimulationResponseDTO: Codable {
    let id: String
    let fileName: String
    let displayName: String
    let description: String
    let statusCode: Int
}
