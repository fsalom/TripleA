//
//  SimulationConfig.swift
//  
//
//  Created by Pablo Ceacero on 26/1/24.
//

import Foundation

public struct SimulationConfig {
    var endpoints: [SimulationEndpoint]

    var endpointsAvailability: [SimulationEndpoint.ID: Bool]
    var simulationResponsesForEndpoint: [SimulationEndpoint.ID: [SimulationResponse.ID]]
    var simulationResponsesAvailability: [SimulationResponse.ID: Bool]

    init() {
        self.endpoints = []
        self.endpointsAvailability = [:]
        self.simulationResponsesForEndpoint = [:]
        self.simulationResponsesAvailability = [:]
    }

    init(endpoints: [SimulationEndpoint],
         endpointsAvailability: [SimulationEndpoint.ID : Bool],
         simulationResponsesForEndpoint: [SimulationEndpoint.ID : [SimulationResponse.ID]],
         simulationResponsesAvailability: [SimulationResponse.ID : Bool]) {
        self.endpoints = endpoints
        self.endpointsAvailability = endpointsAvailability
        self.simulationResponsesForEndpoint = simulationResponsesForEndpoint
        self.simulationResponsesAvailability = simulationResponsesAvailability
    }
}
