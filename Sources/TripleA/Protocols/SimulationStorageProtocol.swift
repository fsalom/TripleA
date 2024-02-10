public enum SimulationStorageKey: String, CaseIterable {
    case simulationConfig
}

public enum SimulationStorageError: Error {
    case valueNotFound
    case keyNotFound
    case impossibleEncode
}

public protocol SimulationStorageProtocol {
    static func setConfig(_ newConfig: SimulationConfig) throws
    static func getConfig() -> SimulationConfig
}
