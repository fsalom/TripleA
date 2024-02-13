//
//  File.swift
//  
//
//  Created by Pablo Ceacero on 9/1/24.
//

import UIKit

class SimulationTableCell: UITableViewCell {

    // MARK: - Cell Dependencies

    struct Dependencies {
        let responseName: String
        let endpointId: SimulationEndpoint.ID
        let responseId: SimulationResponse.ID
        let isResponseSelected: Bool

        init(responseName: String,
             endpointId: SimulationEndpoint.ID,
             responseId: SimulationResponse.ID,
             isResponseSelected: Bool) {
            self.responseName = responseName
            self.endpointId = endpointId
            self.responseId = responseId
            self.isResponseSelected = isResponseSelected
        }
    }

    // MARK: - Views

    private var nameLabel: UILabel!
    private var selectedImageView: UIImageView!
    private var mainStackView: UIStackView!

    // MARK: - Properties

    private var endpointId: SimulationEndpoint.ID!
    private var responseId: SimulationResponse.ID!

    // MARK: - Life Cycle

    override func prepareForReuse() {
        super.prepareForReuse()

        nameLabel.text = nil
        selectedImageView.image = nil
    }

    // MARK: - Setup

    func setup(dependencies: SimulationTableCell.Dependencies) {
        endpointId = dependencies.endpointId
        responseId = dependencies.responseId
        setupMainStackView()
        setupNameLabel(with: dependencies.responseName)
        setupSelectedImageView(isSelected: dependencies.isResponseSelected)
        selectionStyle = .none
    }
}

fileprivate extension SimulationTableCell {
    func setupNameLabel(with text: String) {
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = text
        mainStackView.addArrangedSubview(nameLabel)
    }

    func setupSelectedImageView(isSelected: Bool) {
        selectedImageView = UIImageView(image: UIImage.init(systemName: "checkmark"))
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(selectedImageView)
        manageSelectedImageViewVisibility(by: isSelected,animated: false)
    }

    func setupMainStackView() {
        mainStackView = UIStackView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        mainStackView.spacing = Constants.mainStackSpacing
        setupMainStackViewContraints()
    }

    func setupMainStackViewContraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.mainStackVerticalAndHorizontalPadding),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.mainStackVerticalAndHorizontalPadding),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.mainStackVerticalAndHorizontalPadding),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.mainStackVerticalAndHorizontalPadding),
        ])
    }

    func manageSelectedImageViewVisibility(by isSelected: Bool, animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.15) { [weak self] in
                self?.selectedImageView?.alpha = isSelected ? 1 : 0
            }
        } else {
            selectedImageView?.alpha = isSelected ? 1 : 0
        }
    }
}

extension SimulationTableCell {
    enum Constants {
        static let mainStackVerticalAndHorizontalPadding = 10.0
        static let mainStackSpacing = 10.0
    }
}
