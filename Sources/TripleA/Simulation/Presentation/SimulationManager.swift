//
//  SimulationManager.swift
//  
//
//  Created by Pablo Ceacero on 9/1/24.
//

import UIKit

public class SimulationManager {

    // MARK: - Properties
    private static let storage = SimulationStorageDefaults()

    // MARK: - SETUP

    public static func setupSimulations(_ endpoints: [SimulationEndpoint]) throws {
        var config = SimulationManager.getCurrentConfig()

        for endpoint in endpoints {

            if config.endpoints.contains(endpoint) {
                continue
            }

            config.endpoints = endpoints
            config.endpointsAvailability[endpoint.id] = false
            config.simulationResponsesForEndpoint[endpoint.id] = endpoint.responses.map{ $0.id }
            endpoint.responses.forEach { simulationResponse in
                config.simulationResponsesAvailability[simulationResponse.id] = false
            }
        }

        try SimulationManager.setCurrentConfig(for: config)
    }

    // MARK: - GETTERS
    
    // ENDPOINT

    public static func simulatedEndpoints() -> [SimulationEndpoint] {
        SimulationManager.getCurrentConfig().endpoints
    }

    public static func isEndpointEnabled(_ endpointId: SimulationEndpoint.ID) -> Bool {
        SimulationManager.getCurrentConfig().endpointsAvailability[endpointId] ?? false
    }

    // RESPONSE

    public static func responsesForEndpoint(_ endpointId: SimulationEndpoint.ID) -> [SimulationResponse] {
        let config = SimulationManager.getCurrentConfig()
        guard let responsesIds = config.simulationResponsesForEndpoint[endpointId] else { return [] }
        return config.endpoints.flatMap({ $0.responses }).filter({ responsesIds.contains($0.id) })
    }

    public static func isResponseSimulationEnabled(_ responseId: SimulationResponse.ID) -> Bool {
        SimulationManager.getCurrentConfig().simulationResponsesAvailability[responseId] ?? false
    }

    public static func enabledResponseFor(_ endpointId: SimulationEndpoint.ID) -> SimulationResponse? {
        let config = SimulationManager.getCurrentConfig()
        return config.endpoints.first(where: { $0.id == endpointId })?.responses.first(where: { isResponseSimulationEnabled($0.id) })
    }

    // MARK: - SETTERS

    public static func setEndpointSimulationEnabled(_ endpointId: SimulationEndpoint.ID, enabled: Bool) throws {
        var config = SimulationManager.getCurrentConfig()
        config.endpointsAvailability[endpointId] = enabled
        if !enabled {
            let endpointResponses = config.endpoints.first(where: { $0.id == endpointId })?.responses
            endpointResponses?.forEach({ simulationResponse in
                config.simulationResponsesAvailability[simulationResponse.id] = false
            })
        }

        try SimulationManager.setCurrentConfig(for: config)
    }

    public static func setResponseSimulationEnabled(enabled: Bool,
                                                    _ responseId: SimulationResponse.ID,
                                                    from endpointId: SimulationEndpoint.ID) throws {
        var config = SimulationManager.getCurrentConfig()
        let responsesIdsForEndpoint = responsesForEndpoint(endpointId).map({ $0.id })
        config.simulationResponsesAvailability.keys.forEach { keyResponseId in
            if responsesIdsForEndpoint.contains(keyResponseId) {
                config.simulationResponsesAvailability[keyResponseId] = false
            }
        }
        config.simulationResponsesAvailability[responseId] = enabled
        try SimulationManager.setCurrentConfig(for: config)
    }

    // MARK: - SIMULATE

    public static func simulateIfNeeded(for endpointId: SimulationEndpoint.ID) -> SimulationResponse? {
        let config = SimulationManager.getCurrentConfig()
        if config.endpointsAvailability[endpointId] ?? false,
           let response = enabledResponseFor(endpointId) {
            return response
        }

        return nil
    }

    private static func getCurrentConfig() -> SimulationConfig {
        storage.getConfig()
    }

    private static func setCurrentConfig(for config: SimulationConfig) throws {
        try storage.setConfig(config)
    }
}
