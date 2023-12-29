//
//  Toast.swift
//  ParticleMPC
//
//  Created by link on 01/06/2023.
//

import Foundation
import SwiftMessages

class ToastTest {
    static func safeExecute(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.sync(execute: block)
        }
    }
    
    static func showError(_ message: String) {
        safeExecute {
            let view = MessageView.viewFromNib(layout: .cardView)
            
            view.configureTheme(.error)
            
            view.configureDropShadow()
            
            print("toast show error \(message)")
            
            var message = message
            if message.count > 100 {
                message = message.prefix(100) + "..."
            }
            
            view.configureContent(title: "Error", body: message)
            
            view.button?.isHidden = true
            view.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            view.bodyLabel?.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            view.bodyLabel?.numberOfLines = 0
            
            view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            
            (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
            
            SwiftMessages.show(view: view)
        }
    }

    static func showResult(_ message: String) {
        safeExecute {
            let view = MessageView.viewFromNib(layout: .cardView)
            print("toast show result \(message)")
            
            view.configureTheme(.success)
            
            view.configureDropShadow()
            
            var message = message
            if message.count > 100 {
                message = message.prefix(100) + "..."
            }
            
            view.configureContent(title: "Success", body: message)
            
            view.button?.isHidden = true
            view.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            view.bodyLabel?.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            view.bodyLabel?.numberOfLines = 0
            
            view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            
            (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
            
            SwiftMessages.show(view: view)
        }
    }
}
