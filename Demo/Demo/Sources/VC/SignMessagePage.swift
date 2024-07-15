//
//  SignMessagePage.swift
//  ParticleMPC
//
//  Created by link on 01/06/2023.
//

import Foundation
import ParticleAuthCore
import ParticleNetworkBase
import ParticleWalletAPI
import ProgressHUD
import RxSwift
import SwiftMessages
import SwiftyJSON
import UIKit
import Base58_swift

class SignMessagePage: UIViewController {
    static let ScreenWidth = UIScreen.main.bounds.width
    static let ScreenHeight = UIScreen.main.bounds.height
    
    enum SupportMethod {
        case signMessage
        case signMessageUnique
        case signTypedData // evm
        case signTypedDataUnique // evm
        case sendNative
        case sendToken
        case signTransaction // solana
        case signTransactions // solana
    }
    
    let bag = DisposeBag()
    
    let auth = Auth()
    
    private var sourceText: String = ""
    let tableView = UITableView(frame: .zero, style: .plain)
    
    var publicAddress: String? {
        if ParticleNetwork.getChainInfo().chainType != .solana {
            let publicAddress = auth.evm.getAddress()
            
            return publicAddress
        } else {
            let publicAddress = auth.solana.getAddress()
            
            return publicAddress
        }
    }
    
    let supportMethod: SupportMethod
    var message: String?
    init(supportMethod: SupportMethod, message: String? = nil) {
        self.supportMethod = supportMethod
        self.message = message
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("SignMessagePage deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.colorAnimation = .systemPurple
        ProgressHUD.colorProgress = .systemPurple
        ProgressHUD.animationType = AnimationType.circleStrokeSpin
        setUI()
        
        switch supportMethod {
        case .signMessage:
            if ParticleNetwork.getChainInfo().chainType != .solana {
                setSourceText(message ?? "hello world")
            } else {
                // "hello world" encoded to base58
                setSourceText(message ?? Base58.encode("hello world".data(using: .utf8)!))
            }
        case .signMessageUnique:
            setSourceText(message ?? "hello world")
        case .signTypedData:
            setSourceText(message ?? getTypedDataV4())
        case .signTypedDataUnique:
            setSourceText(message ?? getTypedDataV4())
        case .sendNative:
            if publicAddress == nil {
                setSourceText("not login, public address is nil")
                return
            }
            
            setSourceText("waiting configure transactions")
            
            if ParticleNetwork.getChainInfo().chainType != .solana {
                let dict = ["value": "0x38D7EA4C68000", // 10^15
                            "data": "0x",
                            "from": publicAddress!,
                            "to": "0xa0869E99886e1b6737A4364F2cf9Bb454FD637E4"]
                let string = "0x" + (try! JSONEncoder().encode(dict)).toHexString()
                
//                sourceTextView.text = string
                var amount: String
                if ParticleNetwork.getChainInfo().isTron {
                    amount = "0x3E8"
                } else {
                    amount = "0x38D7EA4C68000"
                }
                
                setSourceText("""
                {
                "data": "0x",
                "from": "\(publicAddress!)",
                "to": "0xa0869E99886e1b6737A4364F2cf9Bb454FD637E4",
                "value": "\(amount)"
                }
                """)
                
            } else {
                let receiverAddress = "9LR6zGAFB3UJcLg9tWBQJxEJCbZh2UTnSU14RBxsK1ZN"
                
                Task {
                    do {
                        let transaction = try await self.getSolanaNativeTransaction(publicAddress: self.publicAddress!, receiverAddress: receiverAddress)
                       
                        DispatchQueue.main.async {
                            self.setSourceText(transaction)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.setResultSignature(String(describing: error))
                        }
                    }
                }
            }
           
        case .sendToken:
           
            if publicAddress == nil {
                setSourceText("not login, public address is nil")
                
                return
            }
            enabledSignBtn(false)
            setSourceText("waiting configure transactions")
            if ParticleNetwork.getChainInfo().chainType != .solana {
                let contractAddress = "0x326C977E6efc84E512bB9C30f76E30c160eD06FB"
                
                let receiver = "0xa0869E99886e1b6737A4364F2cf9Bb454FD637E4"
                
                ParticleWalletAPI.getEvmService().createTransaction(from: publicAddress!, to: contractAddress, contractParams: .erc20Transfer(contractAddress: contractAddress, to: receiver, amount: BInt(1000000000000000))).subscribe { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .failure(let error):
                        self.setResultSignature(String(describing: error))
                    case .success(let tx):
                        self.setSourceText(tx)
                        self.enabledSignBtn(true)
                    }
                }.disposed(by: bag)
            } else {
                let receiverAddress = "9LR6zGAFB3UJcLg9tWBQJxEJCbZh2UTnSU14RBxsK1ZN"
                let mintAddress = "GobzzzFQsFAHPvmwT42rLockfUCeV3iutEkK218BxT8K"
                Task {
                    do {
                        let transaction = try await self.getSolanaTokenTransaction(publicAddress: self.publicAddress!, receiverAddress: receiverAddress, mintAddress: mintAddress, amount: ParticleNetworkBase.BInt(10000))
                        
                        DispatchQueue.main.async {
                            self.setSourceText(transaction)
                            self.enabledSignBtn(true)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.setResultSignature(String(describing: error))
                        }
                    }
                }
            }
            
        case .signTransaction:
            
            if publicAddress == nil {
                setSourceText("not login, public address is nil")
                
                return
            }
            enabledSignBtn(false)
            
            setSourceText("waiting configure transactions")
            
            let receiverAddress = "9LR6zGAFB3UJcLg9tWBQJxEJCbZh2UTnSU14RBxsK1ZN"
            
            Task {
                do {
                    let transaction = try await self.getSolanaNativeTransaction(publicAddress: self.publicAddress!, receiverAddress: receiverAddress)
                   
                    DispatchQueue.main.async {
                        self.setSourceText(transaction)
                        self.enabledSignBtn(true)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.setResultSignature(String(describing: error))
                    }
                }
            }
                   
        case .signTransactions:
            
            if publicAddress == nil {
                setSourceText("not login, public address is nil")
                return
            }
            enabledSignBtn(false)
            
            setSourceText("waiting configure transactions")
            
            let receiverAddress = "9LR6zGAFB3UJcLg9tWBQJxEJCbZh2UTnSU14RBxsK1ZN"
            let mintAddress = "GobzzzFQsFAHPvmwT42rLockfUCeV3iutEkK218BxT8K"
            Task {
                do {
                    let transaction1 = try await self.getSolanaNativeTransaction(publicAddress: self.publicAddress!, receiverAddress: receiverAddress)
                    let transaction2 = try await self.getSolanaTokenTransaction(publicAddress: self.publicAddress!, receiverAddress: receiverAddress, mintAddress: mintAddress, amount: ParticleNetworkBase.BInt(10000))
                    
                    DispatchQueue.main.async {
                        self.setSourceText([transaction1, transaction2].joined(separator: ","))
                        self.enabledSignBtn(true)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.setResultSignature(String(describing: error))
                    }
                }
            }
        }
    }
    
    private func setUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SignCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 400
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
    }
    
    private func sign(_ message: String) {
        ProgressHUD.animate(interaction: false)
        Task {
            do {
                let chainInfo = ParticleNetwork.getChainInfo()
                var signature: String
                switch self.supportMethod {
                case .signMessage:
                    if chainInfo.chainType == .solana {
                        signature = try await self.auth.solana.signMessage(message, chainInfo: chainInfo)
                    } else {
                        signature = try await self.auth.evm.personalSign(message, chainInfo: chainInfo)
                    }
                   
                case .signMessageUnique:
                    signature = try await self.auth.evm.personalSign(message, chainInfo: chainInfo)
                case .signTypedData:
                    signature = try await self.auth.evm.signTypedData(message, chainInfo: chainInfo)
                case .signTypedDataUnique:
                    signature = try await self.auth.evm.signTypedDataUnique(message, chainInfo: chainInfo)
                case .sendToken:
                    if chainInfo.chainType == .solana {
                        signature = try await self.auth.solana.signAndSendTransaction(message, chainInfo: chainInfo)
                    } else {
                        signature = try await self.auth.evm.sendTransaction(message, chainInfo: chainInfo)
                    }
                case .sendNative:
                    if chainInfo.chainType == .solana, !message.isValidBase58String() {
                        throw ParticleNetwork.ResponseError(code: nil, message: "transaction is not ready or not valid")
                    }
                    
                    if chainInfo.chainType == .solana {
                        signature = try await self.auth.solana.signAndSendTransaction(message, chainInfo: chainInfo)
                    } else {
                        signature = try await self.auth.evm.sendTransaction(message, chainInfo: chainInfo)
                    }
                    
                case .signTransaction:
                    if chainInfo.chainType == .solana, !message.isValidBase58String() {
                        throw ParticleNetwork.ResponseError(code: nil, message: "transaction is not ready or not valid")
                    }
                    signature = try await self.auth.solana.signTransaction(message, chainInfo: chainInfo)
                case .signTransactions:
                    
                    let messages = message.split(separator: ",").map {
                        String($0)
                    }
                    try messages.forEach { message in
                        if chainInfo.chainType == .solana, !message.isValidBase58String() {
                            throw ParticleNetwork.ResponseError(code: nil, message: "transaction is not ready or not valid")
                        }
                    }
                    
                    let signatures = try await self.auth.solana.signAllTransactions(messages, chainInfo: chainInfo)
                    signature = String(signatures.joined(separator: ","))
                }
                
                DispatchQueue.main.async {
                    self.setResultSignature(signature)
                    ProgressHUD.dismiss()
                }
                ToastTest.showResult("sign success \(signature)")
            } catch {
                DispatchQueue.main.async {
                    self.setResultSignature(String(describing: error))
                    ProgressHUD.dismiss()
                }
                ToastTest.showError("sign error \(error)")
            }
        }
    }
    
    private func getTypedDataV4() -> String {
        let typedData = """
        {"types":{"OrderComponents":[{"name":"offerer","type":"address"},{"name":"zone","type":"address"},{"name":"offer","type":"OfferItem[]"},{"name":"consideration","type":"ConsiderationItem[]"},{"name":"orderType","type":"uint8"},{"name":"startTime","type":"uint256"},{"name":"endTime","type":"uint256"},{"name":"zoneHash","type":"bytes32"},{"name":"salt","type":"uint256"},{"name":"conduitKey","type":"bytes32"},{"name":"counter","type":"uint256"}],"OfferItem":[{"name":"itemType","type":"uint8"},{"name":"token","type":"address"},{"name":"identifierOrCriteria","type":"uint256"},{"name":"startAmount","type":"uint256"},{"name":"endAmount","type":"uint256"}],"ConsiderationItem":[{"name":"itemType","type":"uint8"},{"name":"token","type":"address"},{"name":"identifierOrCriteria","type":"uint256"},{"name":"startAmount","type":"uint256"},{"name":"endAmount","type":"uint256"},{"name":"recipient","type":"address"}],"EIP712Domain":[{"name":"name","type":"string"},{"name":"version","type":"string"},{"name":"chainId","type":"uint256"},{"name":"verifyingContract","type":"address"}]},"domain":{"name":"Seaport","version":"1.1","chainId":\(ParticleNetwork.getChainInfo().chainId),"verifyingContract":"0x00000000006c3852cbef3e08e8df289169ede581"},"primaryType":"OrderComponents","message":{"offerer":"0x6fc702d32e6cb268f7dc68766e6b0fe94520499d","zone":"0x0000000000000000000000000000000000000000","offer":[{"itemType":"2","token":"0xd15b1210187f313ab692013a2544cb8b394e2291","identifierOrCriteria":"33","startAmount":"1","endAmount":"1"}],"consideration":[{"itemType":"0","token":"0x0000000000000000000000000000000000000000","identifierOrCriteria":"0","startAmount":"9750000000000000","endAmount":"9750000000000000","recipient":"0x6fc702d32e6cb268f7dc68766e6b0fe94520499d"},{"itemType":"0","token":"0x0000000000000000000000000000000000000000","identifierOrCriteria":"0","startAmount":"250000000000000","endAmount":"250000000000000","recipient":"0x66682e752d592cbb2f5a1b49dd1c700c9d6bfb32"}],"orderType":"0","startTime":"1669188008","endTime":"115792089237316195423570985008687907853269984665640564039457584007913129639935","zoneHash":"0x3000000000000000000000000000000000000000000000000000000000000000","salt":"48774942683212973027050485287938321229825134327779899253702941089107382707469","conduitKey":"0x0000000000000000000000000000000000000000000000000000000000000000","counter":"0"}}
        """
        return typedData
    }
    
    private func getSolanaNativeTransaction(publicAddress: String, receiverAddress: String) async throws -> String {
        return try await ParticleWalletAPI.getSolanaService().serializeTransaction(type: .transferSol, sender: publicAddress, receiver: receiverAddress, lamports: 100000, mintAddress: nil, payer: nil).map {
            $0.stringValue
        }.value
    }
    
    private func getSolanaTokenTransaction(publicAddress: String, receiverAddress: String, mintAddress: String, amount: ParticleNetworkBase.BInt) async throws -> String {
        return try await ParticleWalletAPI.getSolanaService().serializeTransaction(type: .transferToken, sender: publicAddress, receiver: receiverAddress, lamports: amount, mintAddress: mintAddress, payer: nil).map {
            $0.stringValue
        }.value
    }
}

struct RecentBlockHash: Codable {
    struct Context: Codable {
        let slot: Int
    }
    
    struct Value: Codable {
        struct FeeCalculator: Codable {
            let lamportsPerSignature: Int
        }
        
        let blockhash: String
        let feeCalculator: FeeCalculator
    }
    
    let context: Context
    let value: Value
}

extension SignMessagePage {
    func setSourceText(_ text: String) {
        sourceText = text
        if let cell = tableView.cellForRow(at: .init(row: 0, section: 0)) as? SignCell {
            cell.sourceTextView.text = text
        }
    }
    
    func getSourceText() -> String {
        if let cell = tableView.cellForRow(at: .init(row: 0, section: 0)) as? SignCell {
            return cell.sourceTextView.text
        }
        
        return ""
    }
    
    func setResultSignature(_ text: String) {
        if let cell = tableView.cellForRow(at: .init(row: 0, section: 0)) as? SignCell {
            cell.resultTextView.text = text
        }
    }
    
    func enabledSignBtn(_ isEnabled: Bool) {
        if let cell = tableView.cellForRow(at: .init(row: 0, section: 0)) as? SignCell {
            cell.signBtn.isEnabled = isEnabled
        }
    }
}

extension SignMessagePage: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SignCell
        cell.sourceTextView.text = sourceText
        cell.signHandler = { [weak self] in
            guard let self = self else { return }
            
            var message = self.getSourceText()
            
            if ParticleNetwork.getChainInfo().chainType != .solana {
                if self.supportMethod == .sendToken || self.supportMethod == .sendNative {
                    if message.isValidHexString() {
                    } else {
                        message = "0x" + ((try? JSON(parseJSON: message).rawData())?.toHexString() ?? "")
                    }
                }
            }
            
            self.sign(message)
        }
        
        return cell
    }
}
