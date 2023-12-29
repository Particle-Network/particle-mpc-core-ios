//
//  LoginTestViewController.swift
//  ParticleMPC
//
//  Created by link on 16/05/2023.
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
    
    enum TestCase: String, CaseIterable {
        case jwt = "JWT"
        case email = "Email"
        case google
        case apple
        case facebook
        case github
        case twitter
        case discord
        case twitch
        case linkedin
        case microsoft
        case uiEmail = "Present UI Email"
        case uiPhone = "Present UI Phone"
    }
    
//    let data: [TestCase] = [.jwt]
    var data: [[TestCase]] = []
    
    var headerView: LoginHeaderView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerView = LoginHeaderView(frame: .init(x: 0, y: 0, width: self.view.bounds.width, height: 200))
        
        self.tableView.tableHeaderView = self.headerView
        
        let footerView = UIView(frame: .init(x: 0, y: 0, width: self.view.bounds.width, height: 100))
        self.tableView.tableFooterView = footerView
        
        self.tableView.register(LoginJWTCell.self, forCellReuseIdentifier: NSStringFromClass(LoginJWTCell.self))
        self.tableView.register(LoginEmailCell.self, forCellReuseIdentifier: NSStringFromClass(LoginEmailCell.self))
        self.tableView.register(LoginSocialCell.self, forCellReuseIdentifier: NSStringFromClass(LoginSocialCell.self))
        self.tableView.register(LoginPresetCell.self, forCellReuseIdentifier: NSStringFromClass(LoginPresetCell.self))
        
        self.data = [[.jwt],
                     [.email],
                     [.google, .apple, .facebook, .twitter, .discord, .linkedin, .microsoft, .github, .twitch],
                     [.uiEmail, .uiPhone]]
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.data[indexPath.section][indexPath.row] {
        case .jwt: return 200
        case .email: return 180
        case .uiEmail, .uiPhone: return 80
        default: return 70
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "JWT Login"
        } else if section == 1 {
            return "Email or Phone Login"
        } else if section == 2 {
            return "Social Login"
        } else {
            return "UI Login"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(LoginJWTCell.self), for: indexPath) as! LoginJWTCell
            cell.selectionStyle = .none
            cell.confirmHandler = { [weak self] jwt in
                guard let self = self else { return }
                Task {
                    do {
                        let userInfo = try await self.auth.connect(type: .jwt, account: jwt)
                        self.handleUserInfo(userInfo)
                    } catch {
                        ToastTest.showError("login failure, \(error)")
                    }
                }
            }
            
            return cell
        } else if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(LoginEmailCell.self), for: indexPath) as! LoginEmailCell
            cell.selectionStyle = .none
            cell.sendHandler = { [weak self] text in
                guard let self = self else { return }
                
                var email: String?
                var phone: String?
                if text.contains("@") {
                    email = text
                } else {
                    phone = text
                }
                
                Task {
                    do {
                        if email != nil {
                            var result = try await self.auth.sendEmailCode(email: email!)
                            ToastTest.showResult("send code success")
                        } else if phone != nil {
                            var result = try await self.auth.sendPhoneCode(phone: phone!)
                            ToastTest.showResult("send code success")
                        }
                        
                    } catch {
                        ToastTest.showError("send code failure, \(error)")
                    }
                }
            }
            
            cell.confirmHandler = { [weak self] text, code in
                guard let self = self else { return }
                var email = ""
                var phone = ""
                if text.contains("@") {
                    email = text
                } else {
                    phone = text
                }
                
                Task {
                    do {
                        let userInfo = try await self.auth.connect(type: !email.isEmpty ? .email : .phone, account: !email.isEmpty ? email : phone, code: code)
                        self.handleUserInfo(userInfo)
                    } catch {
                        ToastTest.showError("login failure, \(error)")
                    }
                }
            }
            return cell
        } else if section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(LoginSocialCell.self), for: indexPath) as! LoginSocialCell
            cell.setTitle("\(self.data[indexPath.section][indexPath.row].rawValue.capitalized) Login")
            cell.confirmHandler = { [weak self] in
                guard let self = self else { return }
                let type: LoginType = .init(rawValue: self.data[indexPath.section][indexPath.row].rawValue.lowercased())!
                Task {
                    do {
                        let userInfo = try await self.auth.connect(type: type, socialLoginPrompt: self.headerView.getSocialLoginPrompt())
                        self.handleUserInfo(userInfo)
                    } catch {
                        ToastTest.showError("login failure, \(error)")
                    }
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(LoginPresetCell.self), for: indexPath) as! LoginPresetCell
            cell.setTitle("\(self.data[indexPath.section][indexPath.row].rawValue) Login")
            let model = self.data[indexPath.section][indexPath.row]
            
            if model == .uiEmail {
                cell.setPlaceholder("Preset email address")
            } else {
                cell.setPlaceholder("Preset phone number")
            }
            cell.confirmHandler = { [weak self] text in
                guard let self = self else { return }
                let model = self.data[indexPath.section][indexPath.row]
                var type: LoginType
                if model == .uiEmail {
                    type = .email
                } else {
                    type = .phone
                }
                
                Task {
                    do {
                        let userInfo = try await self.auth.presentLoginPage(type: type, account: text, socialLoginPrompt: self.headerView.getSocialLoginPrompt(), config: nil)
                        self.handleUserInfo(userInfo)
                    } catch {
                        ToastTest.showError("login failure, \(error)")
                    }
                }
            }
            return cell
        }
    }
    
    private func handleUserInfo(_ userInfo: UserInfo) {
        var currentChainAddress: String
        if ParticleNetwork.getChainInfo().chainType == .solana {
            currentChainAddress = userInfo.wallets.first(where: { $0.chainName == "solana"
            })?.publicAddress ?? ""
        } else {
            currentChainAddress = userInfo.wallets.first(where: { $0.chainName == "evm_chain"
            })?.publicAddress ?? ""
        }
        ToastTest.showResult("login success address \(currentChainAddress)")
    }
}
