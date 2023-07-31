//
//  LoginJWTCell.swift
//  Demo
//
//  Created by link on 31/07/2023.
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
    
    private let froceMasterPasswordLabel = UILabel().then {
        $0.text = "Prompt Master Password"
    }
    
    private let segmentedControl = UISegmentedControl(items: ["0", "1", "2"])
    
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
        contentView.addSubview(jwtTextView)
        contentView.addSubview(confirmButton)
        contentView.addSubview(froceMasterPasswordLabel)
        contentView.addSubview(segmentedControl)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        jwtTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(120)
        }
        
        froceMasterPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(jwtTextView.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(18)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.centerY.equalTo(froceMasterPasswordLabel.snp.centerY)
            make.right.equalToSuperview().inset(18)
            make.height.equalTo(20)
            make.width.equalTo(90)
        }
            
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
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
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        print("Selected segment index is \(sender.selectedSegmentIndex)")
        ParticleNetwork.setSecurityAccountConfig(config: .init(promptMasterPasswordSettingWhenLogin: sender.selectedSegmentIndex))
    }
    
    func getJWT() -> String {
        return jwtTextView.text ?? ""
    }
    
    func getNumber() -> Int {
        segmentedControl.selectedSegmentIndex
    }
}
