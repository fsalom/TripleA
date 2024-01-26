public enum SimulationStorageKey: String, CaseIterable {
    case simulationConfig
}

public enum SimulationStorageError: Error {
    case valueNotFound
    case keyNotFound
}

public protocol SimulationStorageProtocol {
    static func setConfig(_ newConfig: SimulationConfig)
    static func getConfig() -> SimulationConfig?
}
