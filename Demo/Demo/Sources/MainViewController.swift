//
//  ViewController.swift
//  Demo
//
//  Created by link on 31/07/2023.
//

import CryptoSwift
import ParticleAuthCore
import ParticleNetworkBase
import RxSwift
import SwiftUI
import UIKit

enum TestCase: String, CaseIterable {
    case login = "Login"
    case logout = "Logout"
    case evmWalletSign = "EVMWalletSign"
    case solanaWalletSign = "SolanaWalletSign"
    case otherApi = "OtherAPI"
    case language = "Language"
    case apperance = "Apperance"
}

class MainViewController: UITableViewController {
    var data: [TestCase] {
        if ParticleNetwork.getChainInfo().chain == .solana {
            return TestCase.allCases.filter { $0 != .evmWalletSign }
        } else {
            return TestCase.allCases.filter { $0 != .solanaWalletSign }
        }
    }
    
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSwitchChainPage()
        
        addTitle()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        
        cell.textLabel?.text = data[indexPath.row].rawValue
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let targetName = Bundle.main.infoDictionary!["CFBundleName"] as! String
        let model = data[indexPath.row]
        
        let vcClass = NSClassFromString("\(targetName).\(model.rawValue)TestViewController") as! TestViewController.Type
        let vc = vcClass.init()
        vc.testCase = model
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func addSwitchChainPage() {
        let networkBtn = UIButton(type: .custom)
        networkBtn.setTitle("Switch", for: .normal)
        networkBtn.setTitleColor(UIColor.systemBlue, for: .normal)
        let item = UIBarButtonItem(customView: networkBtn)
        navigationItem.setRightBarButton(item, animated: true)
        networkBtn.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            
            let vc = SwitchChainViewController()
            vc.selectHandler = { [weak self] in
                self?.addTitle()
                self?.tableView.reloadData()
            }
            self.present(vc, animated: true)
            
        }.disposed(by: bag)
    }
    
    func addTitle() {
        let name = ParticleNetwork.getChainInfo().name
        let network = ParticleNetwork.getChainInfo().network
        
        title = "\(name) \(network.lowercased())"
    }
}
