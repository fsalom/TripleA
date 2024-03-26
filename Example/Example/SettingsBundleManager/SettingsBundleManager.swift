//
//  SettingsBundleManager.swift
//  Example
//
//  Created by Pablo Ceacero on 26/3/24.
//

import Foundation

class SettingsBundleManager {
    enum Keys {
        static let devCode = "developer_code"
    }

    enum Value {
        static let validDevCodes = ["21011545X"]
    }

    static func issimulationEnabled() -> Bool {
        Value.validDevCodes.contains(UserDefaults.standard.string(forKey: Keys.devCode) ?? "")
    }
}
