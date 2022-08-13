//
//  AuthManager.swift
//  Template
//
//  Created by Fernando Salom on 21/12/21.
//  Copyright © 2021 Rudo. All rights reserved.
//

import Foundation

actor AuthManager {
    private var client_id = ""
    private var client_secret = ""
    private var refreshTask: Task<String, Error>?

    init(client_id: String, client_secret: String){
        self.client_id = client_id
        self.client_secret = client_secret
    }

    // MARK: - getAccesToken - return accessToken or error
    func getAccesToken() async throws -> String? {
        guard let accessToken = Persistence.get(stringFor: .access_token) else {
            throw AuthError.missingToken
        }
        return accessToken
    }

    // MARK: - isValid - return if access token is still valid or thrwo an error
    func isValid() async throws -> Bool {
        guard let expires = Calendar.current.date(byAdding: .second, value: Persistence.get(intFor: .expires_in), to: Date()) else {
            throw AuthError.missingExpiresIn
        }
        return expires > Date() ? true : false
    }

    // MARK: - validToken - check if token is valid or refresh token otherwise
    func validToken() async throws -> String {
        if let handle = refreshTask {
            return try await handle.value
        }
        let isValid = try await isValid()
        if isValid {
            guard let accessToken = try await getAccesToken() else {
                throw AuthError.missingToken
            }
            return accessToken
        }
        return try await refreshToken()
    }

    // MARK: - refreshToken - create a task and call refreshToken if needed
    func refreshToken() async throws -> String {
        if let refreshTask = refreshTask {
            return try await refreshTask.value
        }
        let task = Task { () throws -> String in
            defer { refreshTask = nil }
            guard let refreshToken = Persistence.get(stringFor: .refresh_token) else {
                throw AuthError.tokenNotFound
            }
            return try await refresh(with: refreshToken)
        }
        self.refreshTask = task
        return try await task.value
    }

    // MARK: - authenticate - call to login service
    func authenticate(with parameters: [String: Any]) async throws -> String {
        do {
            let token = try await Network.load(endpoint: AuthEndpoint.login(parameters).endpoint, of: TokenDTO.self)
            save(this: token)
            return token.accessToken
        } catch let error {
            Log.thisError(error)
            throw AuthError.badRequest
        }
    }

    // MARK: - save - save token data
    func save(this token: TokenDTO) {
        Persistence.set(Persistence.Key.access_token, token.accessToken)
        Persistence.set(Persistence.Key.refresh_token, token.refreshToken)
        Persistence.set(Persistence.Key.expires_in, token.expiresIn)
    }

    // MARK: - refresh - call API for refreshToken
    func refresh(with refreshToken: String) async throws -> String {
        do {
            let parameters: [String: Any] = [
                "grant_type": "refresh_token",
                "client_id": self.client_id,
                "client_secret": self.client_secret,
                "refresh_token": refreshToken
            ]
            let token = try await Network.load(endpoint: AuthEndpoint.refreshToken(parameters).endpoint, of: TokenDTO.self)
            save(this: token)
            return token.accessToken
        } catch let error {
            Log.thisError(error)
            Persistence.clear()
            throw AuthError.badRequest
        }
    }
}
