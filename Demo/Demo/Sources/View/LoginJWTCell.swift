//
//  LoginJWTCell.swift
//  ParticleMPC
//
//  Created by link on 16/05/2023.
//

import Foundation
import ParticleNetworkBase
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class LoginJWTCell: UITableViewCell {
    let bag = DisposeBag()
    
    var confirmHandler: ((String) -> Void)?

    private let jwtTextView = UITextView().then {
        $0.text = "paste your jwt here"
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.systemBlue.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
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
        self.selectionStyle = .none
        
        contentView.addSubview(jwtTextView)
        contentView.addSubview(confirmButton)
        
        jwtTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(120)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(jwtTextView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(30)
        }
        
        confirmButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            if let confirmHandler = self.confirmHandler {
                confirmHandler(self.getJWT())
            }
            
        }.disposed(by: bag)
    }
    
    func getJWT() -> String {
        return jwtTextView.text ?? ""
    }
}
