import UIKit
import TripleA

class CryptoListController: UIViewController {

    var simulations: [SimulationEndpoint] = [
        SimulationEndpoint(endpoint: CryptoAPI.assets.endpoint,
                           responses: [
                            SimulationResponse(fileName: "Crypto200OK",
                                               displayName: "Crypto Entities",
                                               description: "Returns list of entities successfully ",
                                               statusCode: 200),
                            SimulationResponse(fileName: "Crypto400KO",
                                               displayName: "Crypto Bad Request Error",
                                               description: "Returns bad request error",
                                               statusCode: 400)
                           ])
    ]

    @IBOutlet weak var tableView: UITableView!

    var viewModel: CryptoListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        SimulationManager.setupSimulations(simulations, on: self)
        let router = CryptoListRouter(viewController: self)
        viewModel = CryptoListViewModel(router: router)
        
        loadData()
        configure()
    }

    func loadData(){
        Task {
            await getCryptos()
            tableView.reloadData()
        }
    }

    func getCryptos() async {
        do {
            try await viewModel.getCryptos()
        } catch let error as CustomError{
            let alert = UIAlertController(title: "Status code \(error.code)",
                                          message: "\(error.rawDescription ?? "") \(String(describing: error.raw))",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true)
        } catch {
            let alert = UIAlertController(title: "Error",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}

extension CryptoListController: UITableViewDelegate, UITableViewDataSource {
    func configure(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CryptoCell",
                                 bundle: nil), forCellReuseIdentifier: "CryptoCell")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath) as! CryptoCell
        cell.setup(this: viewModel.cryptos[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cryptos.count
    }

}
