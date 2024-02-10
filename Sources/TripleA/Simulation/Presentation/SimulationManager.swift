//
//  SimulationManager.swift
//  
//
//  Created by Pablo Ceacero on 9/1/24.
//

import UIKit

public class SimulationManager {
    // MARK: - SETUP

    public static func setupSimulations(_ endpoints: [SimulationEndpoint]) {
        var config = SimulationManager.beginUpdates()

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

        SimulationManager.endUpdates(for: config)
    }

    // MARK: - GETTERS
    
    // ENDPOINT

    public static func simulatedEndpoints() -> [SimulationEndpoint] {
        SimulationManager.beginUpdates().endpoints
    }

    public static func isEndpointEnabled(_ endpointId: SimulationEndpoint.ID) -> Bool {
        SimulationManager.beginUpdates().endpointsAvailability[endpointId] ?? false
    }

    // RESPONSE

    public static func responsesForEndpoint(_ endpointId: SimulationEndpoint.ID) -> [SimulationResponse] {
        let config = SimulationManager.beginUpdates()
        guard let responsesIds = config.simulationResponsesForEndpoint[endpointId] else { return [] }
        return config.endpoints.flatMap({ $0.responses }).filter({ responsesIds.contains($0.id) })
    }

    public static func isResponseSimulationEnabled(_ responseId: SimulationResponse.ID) -> Bool {
        SimulationManager.beginUpdates().simulationResponsesAvailability[responseId] ?? false
    }

    public static func enabledResponseFor(_ endpointId: SimulationEndpoint.ID) -> SimulationResponse? {
        let config = SimulationManager.beginUpdates()
        return config.endpoints.first(where: { $0.id == endpointId })?.responses.first(where: { isResponseSimulationEnabled($0.id) })
    }

    // MARK: - SETTERS

    public static func setEndpointSimulationEnabled(_ endpointId: SimulationEndpoint.ID, enabled: Bool) {
        var config = SimulationManager.beginUpdates()
        config.endpointsAvailability[endpointId] = enabled
        if !enabled {
            let endpointResponses = config.endpoints.first(where: { $0.id == endpointId })?.responses
            endpointResponses?.forEach({ simulationResponse in
                config.simulationResponsesAvailability[simulationResponse.id] = false
            })
        }

        SimulationManager.endUpdates(for: config)
    }

    public static func setResponseSimulationEnabled(enabled: Bool,
                                                    _ responseId: SimulationResponse.ID,
                                                    from endpointId: SimulationEndpoint.ID) {
        var config = SimulationManager.beginUpdates()
        let responsesIdsForEndpoint = responsesForEndpoint(endpointId).map({ $0.id })
        config.simulationResponsesAvailability.keys.forEach { keyResponseId in
            if responsesIdsForEndpoint.contains(keyResponseId) {
                config.simulationResponsesAvailability[keyResponseId] = false
            }
        }
        config.simulationResponsesAvailability[responseId] = enabled
        SimulationManager.endUpdates(for: config)
    }

    // MARK: - SIMULATE

    public static func simulateIfNeeded(for endpointId: SimulationEndpoint.ID) -> SimulationResponse? {
        let config = SimulationManager.beginUpdates()
        if config.endpointsAvailability[endpointId] ?? false,
           let response = enabledResponseFor(endpointId) {
            return response
        }

        return nil
    }

    private static func beginUpdates() -> SimulationConfig {
        SimulationDataSourceDefaults.getConfig()
    }

    private static func endUpdates(for config: SimulationConfig) {
        do {
            try SimulationDataSourceDefaults.setConfig(config)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
