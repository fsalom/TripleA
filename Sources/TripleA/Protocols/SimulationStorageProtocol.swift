public enum SimulationStorageKey: String, CaseIterable {
    case simulationConfig
}

public enum SimulationStorageError: Error {
    case valueNotFound
    case keyNotFound
    case impossibleEncode
}

public protocol SimulationStorageProtocol {
    func setConfig(_ newConfig: SimulationConfig) throws
    func getConfig() -> SimulationConfig
}
