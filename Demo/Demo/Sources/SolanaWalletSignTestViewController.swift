//
//  SolanaWalletSignTestViewController.swift
//  Demo
//
//  Created by link on 31/07/2023.
//

import Foundation
import UIKit
import ParticleAuthCore

class SolanaWalletSignTestViewController: TestViewController {
    enum TestCase: String, CaseIterable {
        case copyPublicAddress = "Copy public address"
        case signMessage = "Sign message"
        case signTransaction = "Sign transaction"
        case signTransactions = "Sign transactions"
        case sendNative = "Send transaction native"
        case sendToken = "Send transaction token"
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
        case .copyPublicAddress: copyPublicAddressMethod()
        case .signMessage: signMessagePage()
        case .signTransaction: signTransactionPage()
        case .signTransactions: signTransactionsPage()
        case .sendNative: sendNativePage()
        case .sendToken: sendTokenPage()
        }
    }
}

// MARK: - Test Methods

extension SolanaWalletSignTestViewController {
    private func copyPublicAddressMethod() {
        let publicAddress = auth.solana.getAddress() ?? ""
        UIPasteboard.general.string = publicAddress
        ToastTest.showResult("copyed \(publicAddress)")
    }
    
    private func signMessagePage() {
        let vc = SignMessagePage(supportMethod: .signMessage)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func signTransactionPage() {
        let vc = SignMessagePage(supportMethod: .signTransaction)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func signTransactionsPage() {
        let vc = SignMessagePage(supportMethod: .signTransactions)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func sendNativePage() {
        let vc = SignMessagePage(supportMethod: .sendNative)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func sendTokenPage() {
        let vc = SignMessagePage(supportMethod: .sendToken)
        navigationController?.pushViewController(vc, animated: true)
    }
}
