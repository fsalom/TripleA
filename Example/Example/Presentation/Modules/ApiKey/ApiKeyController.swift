import UIKit
import TripleA

class ApiKeyController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: ApiKeyViewModel!

    let endpoints = [SimulationEndpoint(endpoint: MarvelAPI.characters([:]).endpoint,
                                        responses: [SimulationResponse(fileName: "Marvel200OK",
                                                                       displayName: "Marvel characters",
                                                                       description: "Returns list of characters of Marvel",
                                                                       statusCode: 200),
                                                    SimulationResponse(fileName: "Marvel500KO",
                                                                       displayName: "500 server error",
                                                                       description: "Returns 500 server error" ,
                                                                       statusCode: 500)])]

    override func viewDidLoad() {
        super.viewDidLoad()
        SimulationManager.setupSimulations(endpoints, on: self)
        let router = ApiKeyRouter(viewController: self)
        viewModel = ApiKeyViewModel(router: router)
        configure()
        loadData()
    }

    func loadData(){
        Task {
            await getCharacters()
            tableView.reloadData()
        }
    }

    func getCharacters() async {
        do {
            try await viewModel.getCharacters()
        } catch let error as CustomError{
            let alert = UIAlertController(title: "Status code \(error.code)",
                                          message: "\(error.rawDescription ?? "") \(String(describing: error.raw))",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true)
        } catch{
        }
    }
}

extension ApiKeyController: UITableViewDelegate, UITableViewDataSource {
    func configure(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CharacterCell",
                                 bundle: nil), forCellReuseIdentifier: "CharacterCell")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
        cell.setup(this: viewModel.characters[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }

}

