//
//  TestViewController.swift
//  ParticleMPC
//
//  Created by link on 22/05/2023.
//

import Foundation
import UIKit

class TestViewController: UITableViewController {
    var testCase: TestCase = .helper

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.testCase.rawValue
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
