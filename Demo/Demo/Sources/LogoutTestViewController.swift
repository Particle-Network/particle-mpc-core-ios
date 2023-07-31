//
//  LogoutTestViewController.swift
//  Demo
//
//  Created by link on 31/07/2023.
//

import Foundation
import ParticleAuthCore
import ParticleNetworkBase
import UIKit

class LogoutTestViewController: TestViewController {
    enum TestCase: String, CaseIterable {
        case logout = "Logout"
    }

    let data: [TestCase] = TestCase.allCases

    let auth = Auth()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)

        cell.textLabel?.text = data[indexPath.row].rawValue

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch data[indexPath.row] {
        case .logout: logoutMethod()
        }
        ToastTest.showResult("set language success")
    }
}

// MARK: - Test Methods

extension LogoutTestViewController {
    private func logoutMethod() {
        Task {
            do {
                let result = try await auth.disconnect()
                ToastTest.showResult("logout success")
            } catch {
                ToastTest.showResult("logout failure \(error)")
            }
        }
    }
}
