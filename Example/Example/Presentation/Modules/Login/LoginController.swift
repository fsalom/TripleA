import UIKit

class LoginController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!

    var viewModel: OAuthViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let router = OAuthRouter(viewController: self)
        viewModel = OAuthViewModel(router: router)

        setupUI()
    }

    func setupUI() {
        loginButton.setTitleColor(.black, for: .normal)
        setLoginButton()
    }

    func setLoginButton() {
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = UIColor.lightGray
    }

    @IBAction func loginPressed(_ sender: Any) {
        Task {
            do {
                let parameters = ["grant_type": "password",
                                  "username": "desarrollo@rudo.es",
                                  "password": "12345678A",
                                  "client_id": "1gzyJeSOyjUOmbSHREbsothngkBMato1VypQz35D",
                                  "client_secret": "ynM8CpvlDHivO1jma1Q3Jv1RIJraBbJ9EtK5XI3dw4RpkxDgi9cZnmJlQs0XzuVCGWCNwQd8qJKAHFrLdHlRRDIzx8B08HJ0Htu6XFzP4kTRTWYIPHuCpldjouJhKvoA"]
                _ = try await Container.authManager.remoteDataSource.getAccessToken(with: parameters)
                Container.shared.window?.rootViewController = Container.getTabbar()
                Container.shared.window?.makeKeyAndVisible()
            } catch let error {
                print(error)
            }
        }
    }
}
