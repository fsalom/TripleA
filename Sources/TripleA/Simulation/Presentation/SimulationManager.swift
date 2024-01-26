//
//  SimulationManager.swift
//  
//
//  Created by Pablo Ceacero on 9/1/24.
//

import UIKit

public class SimulationManager {
    private static var shared = SimulationManager()

    private var config: SimulationConfig {
        get {
            if let config = SimulationStoreDefaults.getConfig() {
                return config
            } else {
                return SimulationConfig(screensEndpoint: [:],
                                        endpointsAvailability: [:],
                                        simulationResponses: [:],
                                        simulationResponsesAvailability: [:])
            }
        }

        set {
            SimulationStoreDefaults.setConfig(newValue)
        }
    }

    public static func setupSimulations(_ endpoints: [SimulationEndpoint],
                                        on viewController: UIViewController) {
        for endpoint in endpoints {
            if shared.config.endpointsAvailability.keys.contains(where: { $0 == endpoint.id }),
               shared.config.screensEndpoint.values.flatMap({ $0 }).contains(where: {
                   $0 == endpoint
               }) {
                continue
            }
            shared.config.screensEndpoint[String(describing: type(of: viewController))] = endpoints
            shared.config.endpointsAvailability[endpoint.id] = false
            shared.config.simulationResponses[endpoint.id] = endpoint.responses
            endpoint.responses.forEach { simulationResponse in
                shared.config.simulationResponsesAvailability[simulationResponse.id] = false
            }
        }
    }

    public static func simulatedEndpoints(for vc: String) -> [SimulationEndpoint] {
        shared.config.screensEndpoint[vc] ?? []
    }

    public static func isEndpointSimulationEnabled(_ endpointId: SimulationEndpoint.ID) -> Bool {
        shared.config.endpointsAvailability[endpointId] ?? false
    }

    public static func setEndpointSimulationEnabled(_ endpointId: SimulationEndpoint.ID, enabled: Bool) {
        shared.config.endpointsAvailability[endpointId] = enabled
        if !enabled {
            let endpointResponses = shared.config.simulationResponses[endpointId]
            endpointResponses?.forEach({ simulationResponse in
                shared.config.simulationResponsesAvailability[simulationResponse.id] = false
            })
        }
    }

    public static func responsesForEndpoint(_ endpointId: SimulationEndpoint.ID) -> [SimulationResponse] {
        shared.config.simulationResponses[endpointId] ?? []
    }

    public static func isResponseSimulationEnabled(_ responseId: SimulationResponse.ID) -> Bool {
        shared.config.simulationResponsesAvailability[responseId] ?? false
    }

    public static func enabledResponseSimulationFor(_ endpointId: SimulationEndpoint.ID) -> SimulationResponse? {
        shared.config.simulationResponses[endpointId]?.first(where: { isResponseSimulationEnabled($0.id) })
    }

    public static func setResponseSimulationEnabled(_ responseId: SimulationResponse.ID,
                                                    from endpointId: SimulationEndpoint.ID) {
        let responsesIdsForEndpoint = responsesForEndpoint(endpointId).compactMap({ $0.id })
        shared.config.simulationResponsesAvailability.keys.forEach { responseId in
            if responsesIdsForEndpoint.contains(responseId) {
                shared.config.simulationResponsesAvailability[responseId] = false
            }
        }
        shared.config.simulationResponsesAvailability[responseId] = true
    }

    public static func simulateIfNeeded(for endpointId: SimulationEndpoint.ID) -> SimulationResponse? {
        if shared.config.endpointsAvailability[endpointId] ?? false,
           let response = enabledResponseSimulationFor(endpointId) {
            return response
        }

        return nil
    }
}
