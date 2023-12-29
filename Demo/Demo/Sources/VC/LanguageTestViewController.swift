//
//  LanguageTestViewController.swift
//  ParticleMPC
//
//  Created by link on 12/06/2023.
//

import Foundation
import ParticleNetworkBase
import UIKit

class LanguageTestViewController: TestViewController {
    enum TestCase: String, CaseIterable {
        case en = "English"
        case zh_hans = "Chinese Simplified"
        case zh_hant = "Chinese Traditional"
        case ko = "Korean"
        case ja = "Japanese"
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
        case .en: ParticleNetwork.setLanguage(.en)
        case .ja: ParticleNetwork.setLanguage(.ja)
        case .zh_hans: ParticleNetwork.setLanguage(.zh_Hans)
        case .zh_hant: ParticleNetwork.setLanguage(.zh_Hant)
        case .ko: ParticleNetwork.setLanguage(.ko)
        }
        ToastTest.showResult("set language success \(ParticleNetwork.getLanguage().webString)")
    }
}

// MARK: - Test Methods

extension LanguageTestViewController {}
