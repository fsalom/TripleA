//
//  SimulationBuilder.swift
//  
//
//  Created by Pablo Ceacero on 9/1/24.
//

import UIKit

public class SimulationBuilder {
    public static func build(vcToSimulate: UIViewController) -> SimulationViewController {
        let viewModel = SimulationViewModel()

        let viewController = SimulationViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
