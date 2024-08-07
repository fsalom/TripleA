import UIKit
import TripleA

class CryptoListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var viewModel: CryptoListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

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
        } catch{
        }
    }
}

extension CryptoListViewController: UITableViewDelegate, UITableViewDataSource {
    func configure(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CryptoCell",
                                 bundle: nil), forCellReuseIdentifier: "CryptoCell")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "CryptoCell",
            for: indexPath) as? CryptoCell else {
            fatalError("Missing CryptoCell")
        }
        cell.setup(this: viewModel.cryptos[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cryptos.count
    }

}

