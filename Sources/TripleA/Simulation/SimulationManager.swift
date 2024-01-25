//
//  File.swift
//  
//
//  Created by Pablo Ceacero on 9/1/24.
//

import UIKit

public class SimulationManager {
    private static var shared = SimulationManager()

    private var screensEndpoint: [String: [SimulationEndpoint]] = [:]
    private var endpointsAvailability: [SimulationEndpoint.ID: Bool] = [:]

    private var simulationResponses: [SimulationEndpoint.ID: [SimulationResponse]] = [:]
    private var simulationResponsesAvailability: [SimulationResponse.ID: Bool] = [:]

    public static func setupSimulations(_ endpoints: [SimulationEndpoint],
                                        on viewController: UIViewController) {
        for endpoint in endpoints {
            if shared.endpointsAvailability.keys.contains(where: { $0 == endpoint.id }) {
                continue
            }
            shared.screensEndpoint[String(describing: type(of: viewController))] = endpoints
            shared.endpointsAvailability[endpoint.id] = false
            shared.simulationResponses[endpoint.id] = endpoint.responses
            endpoint.responses.forEach { simulationResponse in
                shared.simulationResponsesAvailability[simulationResponse.id] = false
            }
        }
    }

    public static func simulatedEndpoints(for vc: String) -> [SimulationEndpoint] {
        shared.screensEndpoint[vc] ?? []
    }

    public static func isEndpointSimulationEnabled(_ endpointId: SimulationEndpoint.ID) -> Bool {
        shared.endpointsAvailability[endpointId] ?? false
    }

    public static func setEndpointSimulationEnabled(_ endpointId: SimulationEndpoint.ID, enabled: Bool) {
        shared.endpointsAvailability[endpointId] = enabled
        if !enabled {
            let endpointResponses = shared.simulationResponses[endpointId]
            endpointResponses?.forEach({ simulationResponse in
                shared.simulationResponsesAvailability[simulationResponse.id] = false
            })
        }
    }

    public static func responsesForEndpoint(_ endpointId: SimulationEndpoint.ID) -> [SimulationResponse] {
        shared.simulationResponses[endpointId] ?? []
    }

    public static func isResponseSimulationEnabled(_ responseId: SimulationResponse.ID) -> Bool {
        shared.simulationResponsesAvailability[responseId] ?? false
    }

    public static func enabledResponseSimulationFor(_ endpointId: SimulationEndpoint.ID) -> SimulationResponse? {
        shared.simulationResponses[endpointId]?.first(where: { isResponseSimulationEnabled($0.id) })
    }

    public static func setResponseSimulationEnabled(_ responseId: SimulationResponse.ID,
                                                    from endpointId: SimulationEndpoint.ID) {
        let responsesIdsForEndpoint = responsesForEndpoint(endpointId).compactMap({ $0.id })
        shared.simulationResponsesAvailability.keys.forEach { responseId in
            if responsesIdsForEndpoint.contains(responseId) {
                shared.simulationResponsesAvailability[responseId] = false
            }
        }
        shared.simulationResponsesAvailability[responseId] = true
    }

    public static func simulateIfNeeded(for endpointId: SimulationEndpoint.ID) -> SimulationResponse? {
        if shared.endpointsAvailability[endpointId] ?? false,
           let response = enabledResponseSimulationFor(endpointId) {
            return response
        }

        return nil
    }
}
