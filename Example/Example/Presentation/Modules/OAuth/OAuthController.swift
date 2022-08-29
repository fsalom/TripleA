//
//  ViewController.swift
//  Example
//
//  Created by Fernando Salom Carratala on 15/8/22.
//

import UIKit
import TripleA

class OAuthController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var viewModel: OAuthViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let router = OAuthRouter(viewController: self)
        viewModel = OAuthViewModel(router: router)
        
        loadData()
    }

    func loadData(){
        Task {
            do {
                try await viewModel.login()
            } catch {

            }
        }
    }

    func getCryptos() async {
    }
}
