import UIKit

class OAuthController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!

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
        setLoginButton(with: .none)
        setInfoButton(with: .none)
    }

    func setLoginButton(with state: LoginState) {
        viewModel.currentState = state
        switch state {
        case .none:
            loginButton.setTitle("Login", for: .normal)
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

    @IBAction func loginPressed(_ sender: Any) {
        Task {
            do {
                try await viewModel.login()
                self.infoLabel.text = "User logged correctly"
                setLoginButton(with: .logged)
            } catch {
                self.infoLabel.text = "Error executing login"
                setLoginButton(with: .error)
            }
        }
    }

    @IBAction func infoPressed(_ sender: Any) {
        if (viewModel.currentState == .none || viewModel.currentState == .error) {
            self.infoLabel.text = "Login required"
        } else {
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
}
