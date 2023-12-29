//
//  HelperTestViewController.swift
//  ParticleMPC
//
//  Created by link on 16/05/2023.
//

import Foundation
import UIKit
import ParticleMPCCore

class HelperTestViewController: TestViewController {
    let plainText = "Hello world"
    var cipherText: String = ""
    var key: String = ""
    let password = "My password"
    let salt = "My salt salt salt"
    
    enum TestCase: String, CaseIterable {
        case encrypt = "Encrypt"
        case decrypt = "Decrypt"
        case hashPassword = "Hash password"
    }
    
    let data: [TestCase] = TestCase.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        case .encrypt: encryptMethod()
        case .decrypt: decryptMethod()
        case .hashPassword: hashPasswordMethod()
        }
    }
}

// MARK: - Test Methods

extension HelperTestViewController {
    private func encryptMethod() {
        guard !self.key.isEmpty else {
            print("key is empty, you need tap hashPassword first.")
            return
        }
        
        do {
            let cipherText = try ThreshSwift.encrypt(plainText: self.plainText, key: self.key)
            self.cipherText = cipherText
            print("encrypt success, plainTest = \(self.plainText), key = \(self.key), cipherText = \(cipherText)")
        } catch {
            print("encrypt failure, error = \(error)")
        }
    }
    
    private func decryptMethod() {
        guard !self.key.isEmpty else {
            print("key is empty, you need tap hashPassword first.")
            return
        }
        
        do {
            let plainText = try ThreshSwift.decrypt(ciphertext: self.cipherText, key: self.key)
            print("decrypt success, cipherText = \(self.cipherText), key = \(self.key), plainTest = \(plainText)")
        } catch {
            print("decrypt failure, error = \(error)")
        }
    }

    private func hashPasswordMethod() {
        do {
            let result = try ThreshSwift.hashPassword(password: self.password, salt: self.salt)
            
            self.key = result
            
            print("hash password success, password = \(self.password), salt = \(self.salt), result = \(result)")
        } catch {
            print("hash password failure, error = \(error)")
        }
    }
}
