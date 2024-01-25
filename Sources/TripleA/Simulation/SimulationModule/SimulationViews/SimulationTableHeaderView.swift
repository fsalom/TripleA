//
//  SimulationTableHeaderView.swift
//  
//
//  Created by Pablo Ceacero on 23/1/24.
//

import UIKit

// MARK: - SimulationTableHeaderViewProtocol

protocol SimulationTableHeaderViewProtocol: AnyObject {  
    func didEnableReloadView(enabled: Bool)
}

class SimulationTableHeaderView: UITableViewHeaderFooterView {

    // MARK: - Dependencies

    struct Dependencies {
        let screenName: String
    }

    // MARK: - Views

    private var mainStackView: UIStackView!
    private var infoLabel: UILabel!
    private var reloadViewStackView: UIStackView!
    private var reloadViewLabel: UILabel!
    private var reloadViewSwitch: UISwitch!

    // MARK: - Properties

    weak var delegate: SimulationTableHeaderViewProtocol?

    // MARK: - Setup

    public func setup(with dependencies: Dependencies) {
        setupMainStackView()
        setupInfoLabel(with: dependencies.screenName)
        setupReloadViewStackView()
        setupReloadViewLabel()
        setupReloadViewSwitch()
    }


    // Top Padding
    // Info Label Height
    // MainStackView Spacing
    // ReloadViewStackView Height
    // Bottom padding
    public func calculateHeight() -> CGFloat {
        guard let infoTextHeight = infoLabel.text?.size(font: infoLabel.font,
                                                        width: mainStackView.frame.size.width).height else { return 0.0 }
        return (Constants.mainStackViewVerticalPadding * 2) +
        infoTextHeight +
        Constants.stackViewSpacing +
        Constants.reloadViewHeight
    }
}

fileprivate extension SimulationTableHeaderView {
    func setupInfoLabel(with screenName: String) {
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(infoLabel)
        infoLabel.text = String(format: Localizables.info, screenName)
        infoLabel.font = UIFont.systemFont(ofSize: Constants.infoLabelFontSize)
        infoLabel.numberOfLines = 0
    }

    func setupReloadViewStackView() {
        reloadViewStackView = UIStackView()
        reloadViewStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(reloadViewStackView)
        reloadViewStackView.alignment = .center
        reloadViewStackView.spacing = Constants.stackViewSpacing
        setupReloadViewStackViewConstraints()
    }

    func setupReloadViewLabel() {
        reloadViewLabel = UILabel()
        reloadViewLabel.translatesAutoresizingMaskIntoConstraints = false
        reloadViewStackView.addArrangedSubview(reloadViewLabel)
        reloadViewLabel.text = Localizables.reloadView.uppercased()
        reloadViewLabel.font = UIFont.systemFont(ofSize: Constants.reloadViewLabelFontSize)
    }

    func setupReloadViewSwitch() {
        reloadViewSwitch = UISwitch()
        reloadViewSwitch.translatesAutoresizingMaskIntoConstraints = false
        reloadViewStackView.addArrangedSubview(reloadViewSwitch)
        reloadViewSwitch.addTarget(self,
                                   action: #selector(onSwitchValueChanged),
                                   for: .valueChanged)
    }

    func setupMainStackView() {
        mainStackView = UIStackView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        mainStackView.axis = .vertical
        mainStackView.alignment = .leading
        mainStackView.spacing = Constants.stackViewSpacing
        setupMainStackViewConstraints()
    }

    func setupMainStackViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor,
                                               constant: Constants.mainStackViewVerticalPadding),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                  constant: -Constants.mainStackViewVerticalPadding),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                      constant: -Constants.mainStackViewHorizontalPadding),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: Constants.mainStackViewHorizontalPadding),
        ])
    }

    func setupReloadViewStackViewConstraints() {
        NSLayoutConstraint.activate([
            reloadViewStackView.heightAnchor.constraint(equalToConstant: Constants.reloadViewHeight)
        ])
    }

    // MARK: - Observers

    @objc func onSwitchValueChanged(_ switch: UISwitch) {
        delegate?.didEnableReloadView(enabled: `switch`.isOn)
    }
}

// MARK: - Constants & Localizables

private extension SimulationTableHeaderView {
    enum Constants {
        static let reloadViewHeight = 35.0
        static let mainStackViewVerticalPadding = 4.0
        static let mainStackViewHorizontalPadding = 20.0
        static let stackViewSpacing = 12.0
        static let reloadViewLabelFontSize = 16.0
        static let infoLabelFontSize = 12.0
    }

    enum Localizables {
        static let reloadView = "Recargar vista"
        static let info = "En esta pantalla se muestran los servicios de red disponibles que tienen disponible la funcion de simularse en %@.\n\nPara recargar la vista que ha presentado este modo simulación, simplemente activa el siguiente selector:"
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
