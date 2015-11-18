//
//  BaseTableViewController.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 18..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class BaseTableViewController: BaseViewController {

  // MARK: - Property
  
  @IBOutlet weak var tableView: UITableView!

  // MARK: - BaseViewController Methods
  
  override func setUpView() {
    super.setUpView()
    tableView.estimatedRowHeight = kTableViewDefaultHeight
    tableView.rowHeight = UITableViewAutomaticDimension
  }
}
