//
//  SimulationViewController.swift
//  
//
//  Created by Pablo Ceacero on 9/1/24.
//

import UIKit
import os

public class SimulationViewController: UIViewController {

    // MARK: - Dependencies
    public struct Dependencies {
        let viewModel: SimulationViewModel
    }

    // MARK: - Properties

    var viewModel: SimulationViewModel!

    // MARK: - Views

    var headerView: SimulationHeaderView!
    var tableView: UITableView!

    // MARK: - Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // update table header size
        guard let headerView = tableView.tableHeaderView else { return }

        let height = headerView.systemLayoutSizeFitting(CGSize(width: tableView.frame.width,
                                                               height: .greatestFiniteMagnitude),
                                                        withHorizontalFittingPriority: .required,
                                                        verticalFittingPriority: .defaultLow).height

        var frame = headerView.frame

        // avoids infinite loop!
        if height != frame.height {
            frame.size.height = height
            headerView.frame = frame
            tableView.tableHeaderView = headerView
        }
    }
}

// MARK: - Layout

fileprivate extension SimulationViewController {

    func setupView() {
        setupTableView()
        view.backgroundColor = .systemGray5
    }

    func createHeaderView() -> SimulationHeaderView {
        headerView = SimulationHeaderView()
        headerView.setup()
        return headerView
    }

    func setupTableView() {
        tableView = UITableView(frame: .zero,
                                style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SimulationTableCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.register(SimulationSectionHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: Constants.headerIdentifier)

        tableView.tableHeaderView = createHeaderView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        setupTableViewConstraints()
    }

    func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension SimulationViewController: UITableViewDataSource, UITableViewDelegate {

    public func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.getEndpoints().count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.responsesForEndpoint(endpointId: viewModel.getEndpoints()[section].id).count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier,
                                                 for: indexPath) as! SimulationTableCell
        let endpointId = viewModel.getEndpoints()[indexPath.section].id
        let response = viewModel.responsesForEndpoint(endpointId: endpointId)[indexPath.row]
        let isResponseSelected = viewModel.isResponseSimulationEnabled(responseId: response.id)
        cell.setup(dependencies: SimulationTableCell.Dependencies(responseName: response.displayName,
                                                                  endpointId: endpointId,
                                                                  responseId: response.id,
                                                                  isResponseSelected: isResponseSelected))
        return cell
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerIdentifier) as! SimulationSectionHeaderView
        header.delegate = self
        let simulationEndpoint = viewModel.getEndpoints()[section]
        let isEndpointSimulationEnabled = viewModel.isEndpointSimulationEnabled(endpointId: simulationEndpoint.id)
        header.setup(with: SimulationSectionHeaderView.Dependencies(displayName: simulationEndpoint.displayName,
                                                                    endpointId: simulationEndpoint.id,
                                                                    isEndpointSimulationEnabled: isEndpointSimulationEnabled))
        return header
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constants.sectionHeaderHeight
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        do {
            let endpointId = viewModel.getEndpoints()[indexPath.section].id
            let responseId = viewModel.responsesForEndpoint(endpointId: endpointId)[indexPath.row].id
            try viewModel.updateResponseSimulationEnabled(enabled: true, for: responseId, from: endpointId)
            tableView.reloadSections([indexPath.section], with: .automatic)
        } catch {
            Logger().error("Simulation response availability could not be updated: \(error.localizedDescription)")
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }

    }
}

// MARK: - SimulationHeaderViewProtocol

extension SimulationViewController: SimulationSectionHeaderViewProtocol {
    func didEnableEndpoint(_ endpointId: SimulationEndpoint.ID, enabled: Bool) throws {
        try viewModel.updateEndpointSimulationEnabled(for: endpointId, enabled: enabled)
        guard let index = viewModel.getEndpoints().firstIndex(where: { $0.id == endpointId }) else { return }
        tableView.reloadSections([index], with: .automatic)
    }
}

extension SimulationViewController {
    enum Constants {
        static let cellIdentifier = "SimulationTableCell"
        static let headerIdentifier = "SimulationHeaderCell"
        static let sectionHeaderHeight = 60.0
    }
}
