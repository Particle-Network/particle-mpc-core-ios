//
//  LoginTestViewController.swift
//  Demo
//
//  Created by link on 31/07/2023.
//

import Foundation
import ParticleAuthCore
import ParticleNetworkBase
import RxSwift
import SwiftyJSON
import UIKit

class LoginTestViewController: TestViewController {
    let bag = DisposeBag()
    
    let auth = Auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(LoginJWTCell.self, forCellReuseIdentifier: NSStringFromClass(LoginJWTCell.self))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "JWT Login"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(LoginJWTCell.self), for: indexPath) as! LoginJWTCell
        cell.selectionStyle = .none
        cell.confirmHandler = { [weak self] jwt in
            guard let self = self else { return }
            Task {
                do {
                    let userInfo = try await self.auth.connect(jwt: jwt)
                    self.handleUserInfo(userInfo)
                } catch {
                    ToastTest.showError("login failure, \(error)")
                }
            }
        }
            
        return cell
    }
    
    private func handleUserInfo(_ userInfo: UserInfo) {
        var currentChainAddress: String
        if ParticleNetwork.getChainInfo().chain == .solana {
            currentChainAddress = userInfo.wallets.first(where: { $0.chainName == "solana"
            })?.publicAddress ?? ""
        } else {
            currentChainAddress = userInfo.wallets.first(where: { $0.chainName == "evm_chain"
            })?.publicAddress ?? ""
        }
        ToastTest.showResult("login success address \(currentChainAddress)")
    }
}
