//
//  SimulationStoreDefaults.swift
//  
//
//  Created by Pablo Ceacero on 25/1/24.
//

import Foundation

class SimulationStoreDefaults: SimulationStorageProtocol {

    // MARK: - Func

    static func setConfig(_ newConfig: SimulationConfig) {
        let dto = SimulationConfigMapper.toDTO(newConfig)

        let configKey = SimulationStorageKey.simulationConfig.rawValue
        Log.this("Saving - \(configKey)")
        guard let encodedData = try? JSONEncoder().encode(dto) else {
            Log.this("🤬 Error saving - \(configKey) > JSON ENCODER ERROR")
            return
        }
        UserDefaults.standard.set(encodedData, forKey: configKey)
    }

    static func getConfig() -> SimulationConfig? {
        let configKey = SimulationStorageKey.simulationConfig.rawValue
        guard let savedData = UserDefaults.standard.object(forKey: configKey) as? Data  else {
            Log.this("Fetching - \(configKey) > NOT FOUND")
            return nil
        }
        guard let dto = try? JSONDecoder().decode(SimulationConfigDTO.self, from: savedData) else { return nil }
        Log.this("Fetching - \(configKey)")
        let object = SimulationConfigMapper.toEntity(dto)
        return object
    }
}
