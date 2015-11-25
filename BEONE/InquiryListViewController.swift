//
//  InquiryListViewController.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 24..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class InquiryListViewController: BaseTableViewController {
  let inquiryList = InquiryList()
  
  override func setUpData() {
    super.setUpData()
//    inquiryList.fetch()
  }
}

extension InquiryListViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return inquiryList.list.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("myInquiryCell", forIndexPath: indexPath)
    (cell as? InquiryCell)?.configureCell(inquiryList.list[indexPath.row] as! Inquiry, indexPath: indexPath)
    return cell
  }
}

class InquiryCell: UITableViewCell {
  @IBOutlet weak var replyView: UIView!
  @IBOutlet var heightConstraint: NSLayoutConstraint!
  
  func configureCell(inquiry: Inquiry, indexPath: NSIndexPath) {
    if indexPath.row % 3 == 1 {
      replyView.addConstraint(heightConstraint)
    } else {
      replyView.removeConstraint(heightConstraint)
    }
  }
}