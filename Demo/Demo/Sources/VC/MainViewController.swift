//
//  ViewController.swift
//  ParticleMPC
//
//  Created by link on 15/05/2023.
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
    case helper = "Helper"
    case authVc = "AuthVc"
    case evmWalletSign = "EVMWalletSign"
    case solanaWalletSign = "SolanaWalletSign"
    case otherApi = "OtherAPI"
    case language = "Language"
    case apperance = "Apperance"
}

class MainViewController: UITableViewController {
    let auth = Auth()
    
    var data: [TestCase] {
        return TestCase.allCases.filter {
            if isDeveloper {
                return $0 == .login ||
                    $0 == .evmWalletSign ||
                    $0 == .solanaWalletSign ||
                    $0 == .otherApi ||
                    $0 == .language ||
                    $0 == .logout ||
                    $0 == .apperance
                   
            } else {
                return true
            }
        }
    }
    
    var isDeveloper: Bool {
        return true
    }
    
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSwitchChainPage()
        
        addTitle()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        let model = data[indexPath.row]
        
        let targetName = Bundle.main.infoDictionary!["CFBundleName"] as! String
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
