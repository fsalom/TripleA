//
//  SimulationConfigMapper.swift
//  
//
//  Created by Pablo Ceacero on 26/1/24.
//

import Foundation

class SimulationConfigMapper {
    static func toEntity(_ dto: SimulationConfigDTO) -> SimulationConfig {
        return SimulationConfig(endpoints: dto.endpoints.map({ SimulationEndpointMapper.toEntity($0) }),
                                endpointsAvailability: dto.endpointsAvailability,
                                simulationResponsesForEndpoint: dto.simulationResponsesForEndpoint,
                                simulationResponsesAvailability: dto.simulationResponsesAvailability)
    }

    static func toDTO(_ entity: SimulationConfig) -> SimulationConfigDTO {
        return SimulationConfigDTO(endpoints: entity.endpoints.map({ SimulationEndpointMapper.toDTO($0) }),
                                   endpointsAvailability: entity.endpointsAvailability,
                                   simulationResponsesForEndpoint: entity.simulationResponsesForEndpoint,
                                   simulationResponsesAvailability: entity.simulationResponsesAvailability)
    }
}
