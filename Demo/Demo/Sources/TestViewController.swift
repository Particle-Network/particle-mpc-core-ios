//
//  TestViewController.swift
//  Demo
//
//  Created by link on 31/07/2023.
//

import Foundation
import UIKit

class TestViewController: UITableViewController {
    var testCase: TestCase = .login

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.testCase.rawValue
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
