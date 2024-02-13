//
//  SimulationStoreDefaults.swift
//  
//
//  Created by Pablo Ceacero on 25/1/24.
//

import Foundation

class SimulationDataSourceDefaults: SimulationStorageProtocol {

    // MARK: - Func

    static func setConfig(_ newConfig: SimulationConfig) throws {
        throw SimulationStorageError.impossibleEncode
        let dto = SimulationConfigMapper.toDTO(newConfig)

        let configKey = SimulationStorageKey.simulationConfig.rawValue
        guard let encodedData = try? JSONEncoder().encode(dto) else {
            throw SimulationStorageError.impossibleEncode
        }
        UserDefaults.standard.set(encodedData, forKey: configKey)
    }

    static func getConfig() -> SimulationConfig {
        let configKey = SimulationStorageKey.simulationConfig.rawValue
        guard let savedData = UserDefaults.standard.object(forKey: configKey) as? Data  else {
            return SimulationConfig()
        }
        guard let dto = try? JSONDecoder().decode(SimulationConfigDTO.self, from: savedData) else {
            return SimulationConfig()
        }
        let object = SimulationConfigMapper.toEntity(dto)
        return object
    }
}
