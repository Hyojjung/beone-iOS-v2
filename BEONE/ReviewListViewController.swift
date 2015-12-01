//
//  ReviewListViewController.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 24..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class ReviewListViewController: BaseTableViewController {

}

extension ReviewListViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.cell("reviewCell", indexPath: indexPath)
    return cell
  }
}