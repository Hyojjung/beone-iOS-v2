//
//  FirstViewController.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 26..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class FirstViewController: BaseViewController {
  @IBOutlet weak var tableView: UITableView!
  private var templateList = TemplateList()

  @IBAction func signInButtonTapped() {
    let signingStoryboard = UIStoryboard(name: "Signing", bundle: nil)
    let signingViewController = signingStoryboard.instantiateViewControllerWithIdentifier("SigningNavigationView")
    presentViewController(signingViewController, animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.estimatedRowHeight = 44.0
    tableView.rowHeight = UITableViewAutomaticDimension
    
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "onContentSizeChange:",
      name: kNotificationContentsViewLayouted,
      object: nil)
    
  
    if let path = NSBundle.mainBundle().pathForResource("test", ofType: "json")
    {
      if let jsonData = NSData(contentsOfFile: path)
      {
        do {
          let templateListObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
          templateList.assignObject(templateListObject)
          
        } catch _ as NSError{
        }
      }
    }
  }
  
  func onContentSizeChange(notification: NSNotification) {
    if let userInfo = notification.userInfo,
      templateId = userInfo[kNotificationKeyTemplateId] as? NSNumber,
      templateHeight = userInfo[kNotificationKeyHeight] as? CGFloat {
      for (index, template) in (templateList.list as! [Template]).enumerate() {
        if template.id == templateId {
          template.height = templateHeight
          tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Automatic)
          break;
        }
      }
    }
  }
}

extension FirstViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return templateList.list.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    tableView.registerNib(UINib(nibName: "TemplateTableViewCell", bundle: nil), forCellReuseIdentifier: "templateTableViewCell")
    let cell = tableView.dequeueReusableCellWithIdentifier("templateTableViewCell", forIndexPath: indexPath) as! TemplateTableViewCell
    cell.configureCell(templateList.list[indexPath.row] as! Template)
    return cell
  }
}

