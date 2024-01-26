//
//  SimulationEndpointMapper.swift
//  
//
//  Created by Pablo Ceacero on 26/1/24.
//

import Foundation

class SimulationEndpointMapper {
    static func toEntity(_ dto: SimulationEndpointDTO) -> SimulationEndpoint {
        return SimulationEndpoint(id: dto.id,
                                  displayName: dto.displayName,
                                  responses: dto.responses.map({ SimulationResponseMapper.toEntity($0) }))
    }

    static func toDTO(_ entity: SimulationEndpoint) -> SimulationEndpointDTO {
        return SimulationEndpointDTO(id: entity.id,
                                     displayName: entity.displayName,
                                     responses: entity.responses.map({ SimulationResponseMapper.toDTO($0) }))
    }
}
