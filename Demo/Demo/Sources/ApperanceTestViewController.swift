//
//  ApperanceTestViewController.swift
//  Demo
//
//  Created by link on 31/07/2023.
//

import Foundation
import ParticleNetworkBase
import UIKit

class ApperanceTestViewController: TestViewController {
    enum TestCase: String, CaseIterable {
        case light = "Light"
        case dark = "Dark"
    }

    let data: [TestCase] = TestCase.allCases

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
        case .light: ParticleNetwork.setInterfaceStyle(.light)
            ToastTest.showResult("set apperance success light")
        case .dark: ParticleNetwork.setInterfaceStyle(.dark)
            ToastTest.showResult("set apperance success dark")
        }
       
    }
}

// MARK: - Test Methods

extension ApperanceTestViewController {}
