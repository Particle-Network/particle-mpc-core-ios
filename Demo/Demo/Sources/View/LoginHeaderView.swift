//
//  LoginHeaderView.swift
//  ParticleMPC
//
//  Created by link on 20/12/2023.
//

import Foundation
import ParticleNetworkBase
import UIKit
import ParticleAuthCore

class LoginHeaderView: UIView {
    private let setMasterPasswordLabel = UILabel().then {
        $0.text = "Prompt Master Password"
        $0.numberOfLines = 0
    }
    
    private let setPaymentPasswordLabel = UILabel().then {
        $0.text = "Prompt Payment Password"
        $0.numberOfLines = 0
    }
    
    private let setSocialLoginPromptLabel = UILabel().then {
        $0.text = "Social Login Prompt"
        $0.numberOfLines = 0
    }
    
    private let blindLabel = UILabel().then {
        $0.text = "Enable Blind Sign"
        $0.numberOfLines = 0
    }
    
    private let masterPasswordSegmentedControl = UISegmentedControl(items: ["0", "1", "2", "3"])
    
    private let paymentPasswordSegmentedControl = UISegmentedControl(items: ["0", "1", "2", "3"])
    
    private let socialLoginPromptSegmentedControl = UISegmentedControl(items: ["none", "consent", "select_account"])
    
    private let blindSignSwitch = UISwitch()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
   
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config() {
        addSubview(setMasterPasswordLabel)
        addSubview(setPaymentPasswordLabel)
        addSubview(masterPasswordSegmentedControl)
        addSubview(paymentPasswordSegmentedControl)
        addSubview(setSocialLoginPromptLabel)
        addSubview(socialLoginPromptSegmentedControl)
        addSubview(blindSignSwitch)
        addSubview(blindLabel)
        
        masterPasswordSegmentedControl.selectedSegmentIndex = ParticleNetwork.getSecurityAccountConfig().promptMasterPasswordSettingWhenLogin
        paymentPasswordSegmentedControl.selectedSegmentIndex = ParticleNetwork.getSecurityAccountConfig().promptSettingWhenSign
        socialLoginPromptSegmentedControl.selectedSegmentIndex = 0
        
        masterPasswordSegmentedControl.addTarget(self, action: #selector(masterPasswordSegmentedControlValueChanged), for: .valueChanged)
        
        paymentPasswordSegmentedControl.addTarget(self, action: #selector(paymentPasswordSegmentedControlValueChanged), for: .valueChanged)
        socialLoginPromptSegmentedControl.addTarget(self, action: #selector(socialLoginPromptSegmentedControlValueChanged), for: .valueChanged)
        
        blindSignSwitch.addTarget(self, action: #selector(blindSignSwitchValueChanged), for: .valueChanged)
        
        setMasterPasswordLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(18)
            make.width.equalTo(150)
        }
        
        setPaymentPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(setMasterPasswordLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(18)
            make.width.equalTo(150)
        }
        
        setSocialLoginPromptLabel.snp.makeConstraints { make in
            make.top.equalTo(setPaymentPasswordLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(18)
            make.width.equalTo(150)
        }
        
        blindLabel.snp.makeConstraints { make in
            make.top.equalTo(setSocialLoginPromptLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(18)
            make.width.equalTo(150)
        }
        
        masterPasswordSegmentedControl.snp.makeConstraints { make in
            make.centerY.equalTo(setMasterPasswordLabel.snp.centerY)
            make.right.equalToSuperview().inset(18)
            make.height.equalTo(20)
            make.width.equalTo(120)
        }
        
        paymentPasswordSegmentedControl.snp.makeConstraints { make in
            make.centerY.equalTo(setPaymentPasswordLabel.snp.centerY)
            make.right.equalToSuperview().inset(18)
            make.height.equalTo(20)
            make.width.equalTo(120)
        }
        
        socialLoginPromptSegmentedControl.snp.makeConstraints { make in
            make.centerY.equalTo(setSocialLoginPromptLabel.snp.centerY)
            make.right.equalToSuperview().inset(18)
            make.height.equalTo(20)
            make.width.equalTo(200)
        }
        
        blindSignSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(blindLabel.snp.centerY)
            make.right.equalToSuperview().inset(18)
            make.height.equalTo(20)
            make.width.equalTo(80)
        }
        
        blindSignSwitch.isOn = Auth.getBlindEnable()
    }
    
    @objc func masterPasswordSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        print("master password selected segment index is \(sender.selectedSegmentIndex)")
        let promptMasterPasswordSettingWhenLogin = getMasterPasswordNumber()
        let promptPaymentPasswordSettingWhenLogin = getPaymentPasswordNumber()
        ParticleNetwork.setSecurityAccountConfig(config: .init(promptSettingWhenSign: promptPaymentPasswordSettingWhenLogin, promptMasterPasswordSettingWhenLogin: promptMasterPasswordSettingWhenLogin))
    }
    
    @objc func paymentPasswordSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        print("payment password selected segment index is \(sender.selectedSegmentIndex)")
        let promptMasterPasswordSettingWhenLogin = getMasterPasswordNumber()
        let promptPaymentPasswordSettingWhenLogin = getPaymentPasswordNumber()
        ParticleNetwork.setSecurityAccountConfig(config: .init(promptSettingWhenSign: promptPaymentPasswordSettingWhenLogin, promptMasterPasswordSettingWhenLogin: promptMasterPasswordSettingWhenLogin))
    }
    
    @objc func socialLoginPromptSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        print("social login prompt segment index is \(sender.selectedSegmentIndex)")
    }
    
    @objc func blindSignSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            Auth.setBlindEnable(true)
        } else {
            Auth.setBlindEnable(false)
        }
    }
    
    func getSocialLoginPrompt() -> SocialLoginPrompt? {
        let index = socialLoginPromptSegmentedControl.selectedSegmentIndex
        guard let value = socialLoginPromptSegmentedControl.titleForSegment(at: index) else {
            return nil
        }
        
        return .init(rawValue: value)
    }
    
    func getMasterPasswordNumber() -> Int {
        masterPasswordSegmentedControl.selectedSegmentIndex
    }
    
    func getPaymentPasswordNumber() -> Int {
        paymentPasswordSegmentedControl.selectedSegmentIndex
    }
}
