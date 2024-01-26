//
//  SimulationConfigMapper.swift
//  
//
//  Created by Pablo Ceacero on 26/1/24.
//

import Foundation

class SimulationConfigMapper {
    static func toEntity(_ dto: SimulationConfigDTO) -> SimulationConfig {
        let screensEndpoint = Dictionary(uniqueKeysWithValues: dto.screensEndpoint.map({
            ($0.key, $0.value.map({ SimulationEndpointMapper.toEntity($0) }))
        }))

        let simulationResponses = Dictionary(uniqueKeysWithValues: dto.simulationResponses.map({
            ($0.key, $0.value.map({ SimulationResponseMapper.toEntity($0) }))
        }))

        return SimulationConfig(screensEndpoint: screensEndpoint,
                                endpointsAvailability: dto.endpointsAvailability,
                                simulationResponses: simulationResponses,
                                simulationResponsesAvailability: dto.simulationResponsesAvailability)
    }

    static func toDTO(_ entity: SimulationConfig) -> SimulationConfigDTO {
        let screensEndpoint = Dictionary(uniqueKeysWithValues: entity.screensEndpoint.map({
            ($0.key, $0.value.map({ SimulationEndpointMapper.toDTO($0) }))
        }))

        let simulationResponses = Dictionary(uniqueKeysWithValues: entity.simulationResponses.map({
            ($0.key, $0.value.map({ SimulationResponseMapper.toDTO($0) }))
        }))

        return SimulationConfigDTO(screensEndpoint: screensEndpoint,
                                   endpointsAvailability: entity.endpointsAvailability,
                                   simulationResponses: simulationResponses,
                                   simulationResponsesAvailability: entity.simulationResponsesAvailability)
    }
}
