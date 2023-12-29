//
//  LoginEmailCell.swift
//  ParticleMPC
//
//  Created by link on 16/05/2023.
//

import Foundation
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class LoginEmailCell: UITableViewCell {
    let bag = DisposeBag()
    
    var sendHandler: ((String) -> Void)?
    var confirmHandler: ((String, String) -> Void)?

    private let emailTextField = UITextField().then {
        $0.placeholder = "email or phone"
    }
    
    private let codeTextField = UITextField().then {
        $0.placeholder = "code"
        $0.keyboardType = .numberPad
    }
    
    private let sendButton = UIButton(type: .system).then {
        $0.setTitle("Send code", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.backgroundColor = .systemBlue
    }
    
    private let confirmButton = UIButton(type: .system).then {
        $0.setTitle("Login", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.backgroundColor = .systemBlue
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        config()
    }
   
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        selectionStyle = .none
        
        contentView.addSubview(emailTextField)
        contentView.addSubview(codeTextField)
        contentView.addSubview(confirmButton)
        contentView.addSubview(sendButton)
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(30)
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(30)
        }
        
        codeTextField.snp.makeConstraints { make in
            make.top.equalTo(sendButton.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(30)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(codeTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(30)
        }
        
        sendButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.codeTextField.resignFirstResponder()
            self.emailTextField.resignFirstResponder()
            self.sendHandler?(self.getEmail())
            
        }.disposed(by: bag)
        
        confirmButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.codeTextField.resignFirstResponder()
            self.emailTextField.resignFirstResponder()
            self.confirmHandler?(self.getEmail(), self.getCode())
            
        }.disposed(by: bag)
    }
    
    func getCode() -> String {
        return codeTextField.text ?? ""
    }
    
    func getEmail() -> String {
        return emailTextField.text ?? ""
    }
}
