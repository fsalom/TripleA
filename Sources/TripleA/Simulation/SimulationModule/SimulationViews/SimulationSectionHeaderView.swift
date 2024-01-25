//
//  File.swift
//  
//
//  Created by Pablo Ceacero on 9/1/24.
//

import UIKit

// MARK: - SimulationSectionHeaderViewProtocol

protocol SimulationSectionHeaderViewProtocol: AnyObject {
    func didEnableEndpoint(_ endpointId: SimulationEndpoint.ID, enabled: Bool)
}

// MARK: - SimulationSectionHeaderView

class SimulationSectionHeaderView: UITableViewHeaderFooterView {

    // MARK: - Dependencies

    struct Dependencies {
        let displayName: String
        let endpointId: SimulationEndpoint.ID
        let isEndpointSimulationEnabled: Bool
    }

    // MARK: - Views

    private var mainStackView: UIStackView!
    private var nameLabel: UILabel!
    private var simulationSwitch: UISwitch!

    // MARK: - Properties

    weak var delegate: SimulationSectionHeaderViewProtocol?
    private var endpointId: SimulationEndpoint.ID!

    // MARK: - Setup

    public func setup(with dependencies: Dependencies) {
        endpointId = dependencies.endpointId
        setupMainStackView()
        setupNameLabel(with: dependencies.displayName)
        setupSimulationSwitch(isOn: dependencies.isEndpointSimulationEnabled)
    }
}

fileprivate extension SimulationSectionHeaderView {
    func setupNameLabel(with name: String) {
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(nameLabel)
        nameLabel.text = name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
    }

    func setupSimulationSwitch(isOn isEndpointSimulationEnabled: Bool) {
        simulationSwitch = UISwitch()
        simulationSwitch.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(simulationSwitch)
        simulationSwitch.addTarget(self,
                                   action: #selector(onSwitchValueChanged),
                                   for: .valueChanged)
        simulationSwitch.setOn(isEndpointSimulationEnabled, animated: false)
    }

    func setupMainStackView() {
        mainStackView = UIStackView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        mainStackView.alignment = .center
        setupMainStackViewConstraints()
    }

    func setupMainStackViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor,
                                                 constant: 4),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                    constant: 4),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                      constant: -20),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: 20),
        ])
    }

    // MARK: - Observers

    @objc func onSwitchValueChanged(_ switch: UISwitch) {
        delegate?.didEnableEndpoint(endpointId, enabled: `switch`.isOn)
    }
}
