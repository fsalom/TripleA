//
//  SimulationTableHeaderView.swift
//  
//
//  Created by Pablo Ceacero on 23/1/24.
//

import UIKit

class SimulationHeaderView: UIView {

    // MARK: - Dependencies

    struct Dependencies {
        let screenName: String
    }

    // MARK: - Views
    private var mainStackView: UIStackView!
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var infoLabel: UILabel!

    // MARK: - Setup

    public func setup(with dependencies: Dependencies) {
        setupMainStackView()
        setupImageView()
        setupTitleLabel()
        setupInfoLabel(with: dependencies.screenName)
    }
}

fileprivate extension SimulationHeaderView {
    func setupImageView() {
        imageView = UIImageView(image: UIImage(systemName: "scribble.variable"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(imageView)
        imageView.backgroundColor = .systemGray5
        imageView.layer.cornerRadius = Constants.imageViewHeightAndWidth / 4
        imageView.layer.borderWidth = 1.5
        imageView.layer.borderColor = UIColor.systemBlue.cgColor
        setupImageViewConstraints()
    }

    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(titleLabel)
        titleLabel.text = Localizables.title
        titleLabel.font = UIFont.systemFont(ofSize: Constants.titleLabelFontSize,
                                            weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
    }

    func setupInfoLabel(with screenName: String) {
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(infoLabel)
        infoLabel.text = String(format: Localizables.info, screenName)
        infoLabel.font = UIFont.systemFont(ofSize: Constants.infoLabelFontSize)
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
    }

    func setupMainStackView() {
        mainStackView = UIStackView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.spacing = Constants.stackViewSpacing
        setupMainStackViewConstraints()
    }

    func setupMainStackViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor,
                                               constant: Constants.mainStackViewTopPadding),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                  constant: -Constants.mainStackViewBottomPadding),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                      constant: -Constants.mainStackViewHorizontalPadding),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: Constants.mainStackViewHorizontalPadding),
        ])
    }

    func setupImageViewConstraints() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageViewHeightAndWidth),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageViewHeightAndWidth)
        ])
    }
}

// MARK: - Constants & Localizables

private extension SimulationHeaderView {
    enum Constants {
        static let mainStackViewTopPadding: CGFloat = 40.0
        static let mainStackViewBottomPadding: CGFloat = 4.0
        static let mainStackViewHorizontalPadding: CGFloat = 20.0
        static let stackViewSpacing: CGFloat = 12.0
        static let imageViewHeightAndWidth: CGFloat = 80.0
        static let titleLabelFontSize: CGFloat = 34.0
        static let infoLabelFontSize: CGFloat = 12.0
    }

    enum Localizables {
        static let title = "Simulación de red"
        static let info = "TripleA te ofrece una opcion de simular los servicios de red que se producen en esta app. De esta manera tanto desarrolladores como testers desempeñan sus tareas en el menor tiempo posible.\n\nEn esta pantalla se muestran los servicios de red disponibles que tienen disponible la funcion de simularse en %@."
    }
}

// MARK: - String Extension

private extension String {
  func size(font: UIFont, width: CGFloat) -> CGSize {
      let attrString = NSAttributedString(string: self, attributes: [.font: font])
        let bounds = attrString.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        let size = CGSize(width: bounds.width, height: bounds.height)
        return size
    }
}
