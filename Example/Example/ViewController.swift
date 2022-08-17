//
//  ViewController.swift
//  Example
//
//  Created by Fernando Salom Carratala on 15/8/22.
//

import UIKit
import TripleA


struct ListDTO: Codable {
    let data : [CryptoDTO]
}

struct CryptoDTO: Codable {
    let name : String!
    let priceUsd : String!
    let changePercent24Hr : String!
}

enum CryptoAPI {
    case assets
    var endpoint: Endpoint {
        get {
            switch self {
            case .assets:
                return Endpoint(path: "/assets", httpMethod: .get)
            }
        }
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let authManager = AuthManager(baseURL: "http://api.coincap.io/v2/", clientId: "", clientSecret: "")
        let network = Network(authManager: authManager)

        Task{
            do {
                let assets = try await network.load(endpoint: CryptoAPI.assets.endpoint, of: ListDTO)
                print(assets)
            } catch {

            }
        }
        // Do any additional setup after loading the view.        
    }


}

