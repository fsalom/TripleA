//
//  SimulationResponse.swift
//  
//
//  Created by Pablo Ceacero on 16/1/24.
//

import Foundation

public struct SimulationResponse: Identifiable {
    public let id: String
    let fileName: String
    let displayName: String
    let description: String
    let statusCode: Int

    let httpResponse: HTTPURLResponse?
    let data: Data?

    public init(fileName: String,
                displayName: String,
                description: String,
                statusCode: Int) {
        self.id = fileName.uppercased()
        self.fileName = fileName
        self.displayName = displayName
        self.description = description
        self.statusCode = statusCode

        if let responseURL = URL(string: "Simulation.TripleA/\(fileName)") {
            self.httpResponse = HTTPURLResponse(url: responseURL,
                                                statusCode: statusCode,
                                                httpVersion: "",
                                                headerFields: [:])
        } else {
            self.httpResponse = nil
        }

        if let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url) {
            self.data = data
        } else {
            self.data = nil
        }
    }
}

// MARK: - Equatable

extension SimulationResponse: Equatable {
    public static func == (lhs: SimulationResponse, rhs: SimulationResponse) -> Bool {
        lhs.id == rhs.id
    }
}
