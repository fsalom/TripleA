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
                return Endpoint(path: "assets", httpMethod: .get)
            }
        }
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let network = Network(baseURL: "https://api.coincap.io/v2/")

        Task{
            do {
                _ = try await network.load(endpoint: CryptoAPI.assets.endpoint, of: ListDTO.self)
            } catch {

            }
        }
        // Do any additional setup after loading the view.        
    }


}

