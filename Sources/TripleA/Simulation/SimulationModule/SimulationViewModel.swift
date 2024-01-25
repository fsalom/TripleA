//
//  File.swift
//  
//
//  Created by Pablo Ceacero on 9/1/24.
//

import Foundation

class SimulationViewModel {

    // MARK: - Properties

    let endpoints: [SimulationEndpoint]

    // MARK: - Init

    init(endpoints: [SimulationEndpoint]) {
        self.endpoints = endpoints
    }

    // MARK: - Public func

    func responsesForEndpoint(endpointId: SimulationEndpoint.ID) -> [SimulationResponse] {
        SimulationManager.responsesForEndpoint(endpointId)
    }

    func isEndpointSimulationEnabled(endpointId: SimulationEndpoint.ID) -> Bool {
        SimulationManager.isEndpointSimulationEnabled(endpointId)
    }

    func isResponseSimulationEnabled(responseId: SimulationResponse.ID) -> Bool {
        SimulationManager.isResponseSimulationEnabled(responseId)
    }

    func updateEndpointSimulationEnabled(for endpointId: SimulationEndpoint.ID, enabled: Bool) {
        SimulationManager.setEndpointSimulationEnabled(endpointId, enabled: enabled)
    }

    func updateResponseSimulationEnabled(for responseId: SimulationResponse.ID,
                                         from endpointId: SimulationEndpoint.ID) {
        SimulationManager.setResponseSimulationEnabled(responseId, from: endpointId)
    }
}
