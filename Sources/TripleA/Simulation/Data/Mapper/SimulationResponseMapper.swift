//
//  SimulationResponseMapper.swift
//  
//
//  Created by Pablo Ceacero on 26/1/24.
//

import Foundation

struct SimulationResponseMapper {
    static func toEntity(_ dto: SimulationResponseDTO) -> SimulationResponse {
        return SimulationResponse(fileName: dto.fileName,
                                  displayName: dto.displayName,
                                  description: dto.description,
                                  statusCode: dto.statusCode)
    }

    static func toDTO(_ entity: SimulationResponse) -> SimulationResponseDTO {
        return SimulationResponseDTO(id: entity.id,
                                     fileName: entity.fileName,
                                     displayName: entity.displayName,
                                     description: entity.description,
                                     statusCode: entity.statusCode)
    }
}
