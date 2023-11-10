//
//  SwitchChainViewController.swift
//  Demo
//
//  Created by link on 31/07/2023.
//

import Foundation
import ParticleAuthCore
import ParticleNetworkBase
import RxSwift
import UIKit

class SwitchChainViewController: UIViewController {
    let bag = DisposeBag()

    var selectHandler: (() -> Void)?
    let tableView = UITableView(frame: .zero, style: .grouped)

    var data: [[String: [ParticleNetwork.ChainInfo]]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
        configureTableView()
    }

    func configureData() {
        let chainInfos = ParticleNetwork.allNetworks

        let groupDict = Dictionary(grouping: chainInfos, by: { $0.uiName })

        data = groupDict.map { [$0.key: $0.value] }.sorted(by: { dict0, dict1 in
            let chainInfo0 = dict0.values.first!.first!
            let chainInfo1 = dict1.values.first!.first!
            let index0 = chainInfos.firstIndex(of: chainInfo0)!
            let index1 = chainInfos.firstIndex(of: chainInfo1)!
            return index0 < index1
        })
    }

    func configureTableView() {
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))

        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SwitchChainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].values.first?.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        let network = data[indexPath.section].values.first?[indexPath.row].network ?? ""
        cell.textLabel?.text = network
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        data[section].keys.first
    }
}

extension SwitchChainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chainInfo = data[indexPath.section].values.first?[indexPath.row] ?? ParticleNetwork.ChainInfo.ethereum(.mainnet)

        let auth = Auth()

        Task {
            do {
                let result = try await auth.switchChain(chainInfo: chainInfo)

                DispatchQueue.main.async {
                    if result == true {
                        if let selectHandler = self.selectHandler {
                            selectHandler()
                        }
                        self.dismiss(animated: true)
                    } else {
                        ToastTest.showError("switch chain failure")
                    }
                }
            } catch {
                ToastTest.showError("switch chain failure \(error)")
            }
        }
    }
}
