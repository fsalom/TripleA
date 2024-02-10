//
//  File.swift
//  
//
//  Created by Pablo Ceacero on 9/1/24.
//

import Foundation

class SimulationViewModel {

    // MARK: - Init

    init() {}

    // MARK: - Public func

    func getEndpoints() -> [SimulationEndpoint] {
        SimulationManager.simulatedEndpoints()
    }

    func responsesForEndpoint(endpointId: SimulationEndpoint.ID) -> [SimulationResponse] {
        SimulationManager.responsesForEndpoint(endpointId)
    }

    func isEndpointSimulationEnabled(endpointId: SimulationEndpoint.ID) -> Bool {
        SimulationManager.isEndpointEnabled(endpointId)
    }

    func isResponseSimulationEnabled(responseId: SimulationResponse.ID) -> Bool {
        SimulationManager.isResponseSimulationEnabled(responseId)
    }

    func updateEndpointSimulationEnabled(for endpointId: SimulationEndpoint.ID, enabled: Bool) {
        SimulationManager.setEndpointSimulationEnabled(endpointId, enabled: enabled)
    }

    func updateResponseSimulationEnabled(enabled: Bool,
                                         for responseId: SimulationResponse.ID,
                                         from endpointId: SimulationEndpoint.ID) {
        SimulationManager.setResponseSimulationEnabled(enabled: enabled,
                                                       responseId,
                                                       from: endpointId)
    }
}
