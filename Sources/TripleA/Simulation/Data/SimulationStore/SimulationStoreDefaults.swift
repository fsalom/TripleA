//
//  SimulationStoreDefaults.swift
//  
//
//  Created by Pablo Ceacero on 25/1/24.
//

import Foundation

class SimulationStorageDefaults: SimulationStorageProtocol {
    private let userDefaults = UserDefaults.standard

    init() {}

    // MARK: - Func

    func setConfig(_ newConfig: SimulationConfig) throws {
        let dto = SimulationConfigMapper.toDTO(newConfig)

        let configKey = SimulationStorageKey.simulationConfig.rawValue
        guard let encodedData = try? JSONEncoder().encode(dto) else {
            throw SimulationStorageError.impossibleEncode
        }
        userDefaults.set(encodedData, forKey: configKey)
    }

    func getConfig() -> SimulationConfig {
        let configKey = SimulationStorageKey.simulationConfig.rawValue
        guard let savedData = userDefaults.data(forKey: configKey) else {
            return SimulationConfig()
        }
        guard let dto = try? JSONDecoder().decode(SimulationConfigDTO.self, from: savedData) else {
            return SimulationConfig()
        }
        let object = SimulationConfigMapper.toEntity(dto)
        return object
    }
}
