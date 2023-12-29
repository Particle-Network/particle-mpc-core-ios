//
//  SignCell.swift
//  ParticleMPC
//
//  Created by link on 14/08/2023.
//

import Foundation
import ParticleNetworkBase
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class SignCell: UITableViewCell {
    let bag = DisposeBag()

    var signHandler: (() -> Void)?
    
    let sourceTextView = UITextView().then {
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.systemBlue.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.isEditable = true
    }
    
    let resultTextView = UITextView().then {
        $0.text = "result is here"
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.systemBlue.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.isEditable = true
    }
    
    let signBtn = UIButton(type: .system).then {
        $0.setTitle("Sign", for: .normal)
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
        
        contentView.addSubview(sourceTextView)
        contentView.addSubview(resultTextView)
        contentView.addSubview(signBtn)
        
        sourceTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.height.equalTo(150)
            make.left.right.equalToSuperview().inset(18)
        }
        
        resultTextView.snp.makeConstraints { make in
            make.top.equalTo(sourceTextView.snp.bottom).offset(30)
            make.height.equalTo(150)
            make.left.right.equalToSuperview().inset(18)
        }
        
        signBtn.snp.makeConstraints { make in
            make.top.equalTo(resultTextView.snp.bottom).offset(30)
            make.height.equalTo(30)
            make.left.right.equalToSuperview().inset(18)
        }
        
        signBtn.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            if let signHandler = self.signHandler {
                signHandler()
            }
        }.disposed(by: self.bag)
    }
}
