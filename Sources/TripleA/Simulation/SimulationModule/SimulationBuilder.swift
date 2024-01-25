//
//  SimulationBuilder.swift
//  
//
//  Created by Pablo Ceacero on 9/1/24.
//

import UIKit

public class SimulationBuilder {
    public static func build(vcToSimulate: UIViewController) -> UINavigationController {
        let screenName = String(describing: type(of: vcToSimulate))
        let simulationEndpoints = SimulationManager.simulatedEndpoints(for: screenName)
        let viewModel = SimulationViewModel(endpoints: simulationEndpoints)

        let viewController = SimulationViewController()
        viewController.viewModel = viewModel
        viewController.targetVC = vcToSimulate
        viewController.targetName = screenName
        let nav = UINavigationController(rootViewController: viewController)
        return nav
    }
}
