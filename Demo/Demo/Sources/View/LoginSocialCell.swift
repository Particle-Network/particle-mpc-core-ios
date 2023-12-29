//
//  LoginSocialCell.swift
//  ParticleMPC
//
//  Created by link on 04/12/2023.
//

import Foundation
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class LoginSocialCell: UITableViewCell {
    let bag = DisposeBag()
    
    var confirmHandler: (() -> Void)?
    
    private let confirmButton = UIButton(type: .system).then {
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
        
        contentView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(18)
            make.height.equalTo(30)
        }
        
        confirmButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            if let confirmHandler = self.confirmHandler {
                confirmHandler()
            }
        }.disposed(by: bag)
    }
    
    func setTitle(_ title: String) {
        confirmButton.setTitle(title, for: .normal)
    }
}
