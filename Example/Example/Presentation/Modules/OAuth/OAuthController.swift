#if canImport(UIKit)
import UIKit

class OAuthController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!

    var viewModel: OAuthViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let router = OAuthRouter(viewController: self)
        viewModel = OAuthViewModel(router: router)
        
        setupUI()
    }

    func setupUI() {
        loginButton.setTitleColor(.black, for: .normal)
        infoButton.setTitleColor(.black, for: .normal)
        refreshButton.setTitleColor(.black, for: .normal)
        logoutButton.setTitleColor(.black, for: .normal)
        setLoginButton(with: .none)
        setInfoButton(with: .none)
        setRefreshButton(with: .none)

        logoutButton.setTitle("Logout", for: .normal)
    }

    func setLoginButton(with state: LoginState) {
        viewModel.currentState = state
        switch state {
        case .none:
            loginButton.setTitle("Logout", for: .normal)
            loginButton.backgroundColor = UIColor.lightGray
        case .logged:
            loginButton.setTitle("Logged In", for: .normal)
            loginButton.backgroundColor = UIColor.green
        case .error:
            loginButton.setTitle("Error", for: .normal)
            loginButton.backgroundColor = UIColor.red
        }
    }

    func setInfoButton(with state: LoginState) {
        viewModel.currentState = state
        switch state {
        case .none:
            infoButton.setTitle("Get Info", for: .normal)
            infoButton.backgroundColor = UIColor.lightGray
        case .logged:
            infoButton.setTitle("OK Info", for: .normal)
            infoButton.backgroundColor = UIColor.green
        case .error:
            infoButton.setTitle("Error", for: .normal)
            infoButton.backgroundColor = UIColor.red
        }
    }

    func setRefreshButton(with state: LoginState) {
        viewModel.currentState = state
        switch state {
        case .none:
            refreshButton.setTitle("Refresh Token", for: .normal)
            refreshButton.backgroundColor = UIColor.lightGray
        case .logged:
            refreshButton.setTitle("OK Refresh", for: .normal)
            refreshButton.backgroundColor = UIColor.green
        case .error:
            refreshButton.setTitle("Error", for: .normal)
            refreshButton.backgroundColor = UIColor.red
        }
    }

    @IBAction func loginPressed(_ sender: Any) {
        Task {
            do {
                try await Container.network.logout()
                self.infoLabel.text = "User logged out correctly"
                setLoginButton(with: .logged)
            } catch {
                self.infoLabel.text = "Error executing logout"
                setLoginButton(with: .error)
            }
        }
    }

    @IBAction func refreshPressed(_ sender: Any) {
        Task {
            do {
                try await Container.network.renewToken()
                self.infoLabel.text = "Token renewed"
                setRefreshButton(with: .logged)
            } catch {
                self.infoLabel.text = "Error executing refresh token"
                setRefreshButton(with: .error)
            }
        }
    }

    @IBAction func logoutPressed(_ sender: Any) {
        Task {
            await Container.shared.authManager.logout()
        }
    }

    @IBAction func infoPressed(_ sender: Any) {
        Task {
            do {
                let user: UserDTO = try await viewModel.getInfo()
                self.infoLabel.text = "User logged with email: \(user.email)"
                setInfoButton(with: .logged)
            } catch {
                self.infoLabel.text = "Error executing endpoint"
                setInfoButton(with: .error)
            }
        }
    }
}
#endif
