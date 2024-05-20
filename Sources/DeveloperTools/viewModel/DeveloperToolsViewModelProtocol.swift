//
//  File.swift
//  
//
//  Created by Fernando Salom Carratala on 20/5/24.
//

import Foundation

public protocol DeveloperToolsViewModelProtocol: ObservableObject {
    func logout()
    func expireAccessToken()
    func expireAccessAndRefreshToken()
    func loadAuthorized()
    func launchParallelCalls()
}
