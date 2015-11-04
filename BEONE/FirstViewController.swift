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
  
  func handleLayoutChange(notification: NSNotification) {
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
  
  func handleAction(notification: NSNotification) {
    if let userInfo = notification.userInfo,
      templateId = userInfo[kNotificationKeyTemplateId] as? NSNumber {
        for template in templateList.list as! [Template] {
          if template.id == templateId {
            if template.contents.count == 1 {
              template.contents.first?.action.action()
            } else if let contentsId = userInfo[kNotificationKeyContentsId] as? NSNumber {
              for contents in template.contents {
                if contents.id == contentsId {
                  contents.action.action()
                }
              }
            }
            break;
          }
        }
    }
  }
  
  override func setUpView() {
    super.setUpView()
    tableView.registerNib(UINib(nibName: kNibNameTemplateTableViewCell, bundle: nil), forCellReuseIdentifier: kCellIdentifierTemplateTableViewCell)
  }
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "handleLayoutChange:",
      name: kNotificationContentsViewLayouted,
      object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self,
      selector: "handleAction:",
      name: kNotificationDoAction,
      object: nil)
  }
  
  override func removeObservers() {
    super.removeObservers()
    NSNotificationCenter.defaultCenter().removeObserver(self)
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
    let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifierTemplateTableViewCell, forIndexPath: indexPath) as! TemplateTableViewCell
    cell.configureCell(templateList.list[indexPath.row] as! Template)
    return cell
  }
}

