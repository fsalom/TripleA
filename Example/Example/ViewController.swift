//
//  ViewController.swift
//  Example
//
//  Created by Fernando Salom Carratala on 15/8/22.
//

import UIKit
import TripleA

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let x = AuthManager(baseURL: "", clientId: "", clientSecret: "")
        let y = Network(authManager: x)
        // Do any additional setup after loading the view.        
    }


}

