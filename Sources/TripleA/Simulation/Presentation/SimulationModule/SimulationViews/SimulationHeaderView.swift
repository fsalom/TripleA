//
//  SimulationTableHeaderView.swift
//  
//
//  Created by Pablo Ceacero on 23/1/24.
//

import UIKit

class SimulationHeaderView: UIView {

    // MARK: - Views
    private var mainStackView: UIStackView!
    private var titleLabel: UILabel!
    private var infoLabel: UILabel!

    // MARK: - Setup

    public func setup() {
        setupMainStackView()
        setupTitleLabel()
        setupInfoLabel()
    }
}

fileprivate extension SimulationHeaderView {
    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(titleLabel)
        titleLabel.text = Localizables.title.uppercased()
        titleLabel.font = UIFont.systemFont(ofSize: Constants.titleLabelFontSize,
                                            weight: .bold)
        titleLabel.numberOfLines = 1
    }

    func setupInfoLabel() {
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(infoLabel)
        infoLabel.text = Localizables.info
        infoLabel.font = UIFont.systemFont(ofSize: Constants.infoLabelFontSize)
        infoLabel.numberOfLines = 0
    }

    func setupMainStackView() {
        mainStackView = UIStackView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        mainStackView.axis = .vertical
        setupMainStackViewConstraints()
    }

    func setupMainStackViewConstraints() {
        let constraints = [
            mainStackView.topAnchor.constraint(equalTo: topAnchor,
                                               constant: Constants.mainStackViewTopPadding),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                  constant: -Constants.mainStackViewBottomPadding),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                      constant: -Constants.mainStackViewHorizontalPadding),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: Constants.mainStackViewHorizontalPadding),
        ]

        NSLayoutConstraint.activate(constraints.map({
            $0.priority = .defaultHigh // avoids constraints conflicts
            return $0
        }))
    }
}

// MARK: - Constants & Localizables

private extension SimulationHeaderView {
    enum Constants {
        static let mainStackViewTopPadding: CGFloat = 20.0
        static let mainStackViewBottomPadding: CGFloat = 8.0
        static let mainStackViewHorizontalPadding: CGFloat = 20.0
        static let titleLabelFontSize: CGFloat = 28.0
        static let infoLabelFontSize: CGFloat = 12.0
    }

    enum Localizables {
        static let title = "Simulador de red"
        static let info = "TripleA ofrece la opción de simular los servicios de red que se consumen en esta app. De esta manera facilita el trabajo de desarrolladores y QA"
    }
}
