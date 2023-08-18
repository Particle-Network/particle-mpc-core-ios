//
//  OtherAPIViewController.swift
//  Demo
//
//  Created by link on 31/07/2023.
//

import Foundation
import ParticleNetworkBase
import UIKit
import ParticleAuthCore

class OtherAPITestViewController: TestViewController {
    enum TestCase: String, CaseIterable {
        case changeMasterPassword = "ChangeMasterPassword"
        case isConnected = "isConnected"
        case syncUserInfo = "syncUserInfo"
    }
        
    let data: [TestCase] = TestCase.allCases

    let auth = Auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
            
        cell.textLabel?.text = self.data[indexPath.row].rawValue
            
        return cell
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.data[indexPath.row] {
        case .changeMasterPassword: changeMasterPasswordMethod()
        case .isConnected: isConnectedMethod()
        case .syncUserInfo: syncUserInfoMethod()
        }
    }
}

// MARK: - Test Methods

extension OtherAPITestViewController {
    private func changeMasterPasswordMethod() {
        Task {
            do {
                let result = try await auth.changeMasterPassword()
                ToastTest.showResult("change master password success, result = \(result)")
            } catch {
                ToastTest.showError("change master password failure, error = \(error)")
                print("change master password failure, error = \(error)")
            }
        }
    }
    
    private func isConnectedMethod() {
        Task {
            do {
                let result = try await auth.isConnected()
                ToastTest.showResult("is connected, result = \(result)")
            } catch {
                ToastTest.showError("is connected failure, error = \(error)")
                print("is connected failure, error = \(error)")
            }
        }
    }
    
    private func syncUserInfoMethod() {
        Task {
            do {
                let result = try await auth.syncUserInfo()
                ToastTest.showResult("syncUserInfo, result = \(result.rawValue)")
            } catch {
                ToastTest.showError("syncUserInfo failure, error = \(error)")
                print("syncUserInfo failure, error = \(error)")
            }
        }
    }
    
    
}

