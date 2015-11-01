//
//  FirstViewController.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 26..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class FirstViewController: BaseViewController {
  @IBOutlet weak var scrollView: UIScrollView!
  
  @IBAction func signInButtonTapped() {
    let signingStoryboard = UIStoryboard(name: "Signing", bundle: nil)
    let signingViewController = signingStoryboard.instantiateViewControllerWithIdentifier("SigningNavigationView")
    presentViewController(signingViewController, animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let templateView = TemplateView()
    templateView.translatesAutoresizingMaskIntoConstraints = false
    
    
    if let path = NSBundle.mainBundle().pathForResource("test", ofType: "json")
    {
      if let jsonData = NSData(contentsOfFile: path)
      {
        do {
          let templateObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
          let template = Template()
          template.assignObject(templateObject)
          
          templateView.layoutView(template)
          scrollView.addSubview(templateView)
          
          scrollView.addConstraint(NSLayoutConstraint(item: templateView, attribute: .Top, relatedBy: .Equal, toItem: scrollView, attribute: .Top, multiplier: 1, constant: 0))
          scrollView.addConstraint(NSLayoutConstraint(item: templateView, attribute: .Bottom, relatedBy: .Equal, toItem: scrollView, attribute: .Bottom, multiplier: 1, constant: 0))
          scrollView.addConstraint(NSLayoutConstraint(item: templateView, attribute: .Left, relatedBy: .Equal, toItem: scrollView, attribute: .Left, multiplier: 1, constant: 0))
          scrollView.addConstraint(NSLayoutConstraint(item: templateView, attribute: .Right, relatedBy: .Equal, toItem: scrollView, attribute: .Right, multiplier: 1, constant: 0))
          scrollView.addConstraint(NSLayoutConstraint(item: templateView, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1, constant: 0))

        } catch _ as NSError{
        }
      }
    }
    
  }
}

