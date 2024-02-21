import UIKit
import TripleA
import os

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        Container.shared.window = window
        let simulations: [SimulationEndpoint] = [
            SimulationEndpoint(endpoint: CryptoAPI.assets.endpoint,
                               responses: [
                                SimulationResponse(fileName: "Crypto200OK",
                                                   displayName: "Crypto Entities",
                                                   description: "Returns list of entities successfully ",
                                                   statusCode: 200),
                                SimulationResponse(fileName: "Crypto400KO",
                                                   displayName: "Error 400",
                                                   description: "Returns list of entities successfully ",
                                                   statusCode: 400),
                                SimulationResponse(fileName: "Crypto401KO",
                                                   displayName: "Error 401",
                                                   description: "Returns list of entities successfully ",
                                                   statusCode: 401),
                                SimulationResponse(fileName: "Crypto403KO",
                                                   displayName: "Error 403",
                                                   description: "Returns list of entities successfully ",
                                                   statusCode: 403),
                                SimulationResponse(fileName: "Crypto404KO",
                                                   displayName: "Error 404",
                                                   description: "Returns list of entities successfully ",
                                                   statusCode: 404),
                                SimulationResponse(fileName: "Crypto405KO",
                                                   displayName: "Error 405",
                                                   description: "Returns list of entities successfully ",
                                                   statusCode: 405),
                                SimulationResponse(fileName: "Crypto406KO",
                                                   displayName: "Error 406",
                                                   description: "Returns list of entities successfully ",
                                                   statusCode: 406),
                                SimulationResponse(fileName: "Crypto407KO",
                                                   displayName: "Error 407",
                                                   description: "Returns list of entities successfully ",
                                                   statusCode: 407),
                                SimulationResponse(fileName: "Crypto408KO",
                                                   displayName: "Error 408",
                                                   description: "Returns list of entities successfully ",
                                                   statusCode: 408),
                                SimulationResponse(fileName: "Crypto500KO",
                                                   displayName: "Error 500",
                                                   description: "Returns list of entities successfully ",
                                                   statusCode: 500)

                               ]),
            SimulationEndpoint(endpoint: MarvelAPI.characters([:]).endpoint,
                               responses: [
                                SimulationResponse(fileName: "Marvel200OK",
                                                   displayName: "Characters list",
                                                   description: "Returns list of entities successfully ",
                                                   statusCode: 200),
                                SimulationResponse(fileName: "Marvel400KO",
                                                   displayName: "Error 400",
                                                   description: "Returns list of entities successfully ",
                                                   statusCode: 400),
                                SimulationResponse(fileName: "Marvel401KO",
                                                   displayName: "Error 401",
                                                   description: "Returns list of entities successfully ",
                                                   statusCode: 401),
                                SimulationResponse(fileName: "Marvel403KO",
                                                   displayName: "Error 403",
                                                   description: "Returns list of entities successfully ",
                                                   statusCode: 403),
                                SimulationResponse(fileName: "Marvel500OK",
                                                   displayName: "Error 500",
                                                   description: "Returns list of entities successfully ",
                                                   statusCode: 500),
                               ])
        ]

        do {
            try SimulationManager.setupSimulations(simulations)
        } catch {
            Logger().error("Simulation could not be setted up: \(error.localizedDescription)")
        }

        Task {
            if await Container.network.authManager?.isLogged ?? false {
                Container.shared.window?.rootViewController = Container.getTabbar()
                Container.shared.window?.makeKeyAndVisible()
            }else{
                Container.shared.window?.rootViewController = Container.getLoginController()
                Container.shared.window?.makeKeyAndVisible()
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

