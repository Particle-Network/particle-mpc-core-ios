//
//  LoginPresetCell.swift
//  ParticleMPC
//
//  Created by link on 22/12/2023.
//

import Foundation
import RxSwift

class LoginPresetCell: UITableViewCell {
    let bag = DisposeBag()
    
    var sendHandler: ((String) -> Void)?
    var confirmHandler: ((String?) -> Void)?

    private let emailTextField = UITextField().then {
        $0.placeholder = "email or phone"
        $0.returnKeyType = .done
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
        contentView.addSubview(confirmButton)
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(30)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(30)
        }
        
        confirmButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.emailTextField.resignFirstResponder()
            self.confirmHandler?(self.getText())
            
        }.disposed(by: bag)
        
        emailTextField.delegate = self
    }
    
    func getText() -> String? {
        return emailTextField.text
    }
    
    func setTitle(_ title: String) {
        confirmButton.setTitle(title, for: .normal)
    }
    
    func setPlaceholder(_ text: String) {
        emailTextField.placeholder = text
    }
}

extension LoginPresetCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            endEditing(true)
            return false
        }
        return true
    }
}
