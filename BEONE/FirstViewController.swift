//
//  FirstViewController.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 26..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
  
  @IBAction func signInButtonTapped() {
    let signingStoryboard = UIStoryboard(name: "Signing", bundle: nil)
    let signingViewController = signingStoryboard.instantiateViewControllerWithIdentifier("SigningNavigationView")
    presentViewController(signingViewController, animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let templateView = TemplateView()
    templateView.translatesAutoresizingMaskIntoConstraints = false
    
    
    let templateObject = [
      "style": [
        "margin": "10 20 10 20",
        "padding": "20 10 20 30",
        "backgroundColor": "#55128736",
        "backgroundImageUrl": "Url String",
        "alignment": "left"
      ],
      "isGroup": true,
      "templateItems": [
        [
          "type": "text",
          "style": [
            "margin": "10 20 10 20",
            "padding": "20 10 20 30",
            "backgroundColor": "#743482",
            "backgroundImageUrl": "Url String",
            "alignment": "center"
          ],
          "contents": [
            [
              "text": "text",
              "alignment": "left",
              "isUnderlined": true,
              "isBold": false,
              "isItalic": true,
              "isCancelLined": false,
              "backgroundColor": "#ffffff",
              "textColor": "#000000",
              "size": 12,
              "action": "Action Object"
            ]
          ]
        ],[
          "type": "image",
          "style": [
            "margin": "0 20 0 20",
            "padding": "20 10 20 30",
            "backgroundColor": "#36485633",
            "backgroundImageUrl": "Url String",
            "alignment": "center"
          ],
          "contents": [
            [
              "text": "text",
              "alignment": "right",
              "isUnderlined": false,
              "isBold": true,
              "isItalic": false,
              "isCancelLined": true,
              "backgroundColor": "#000000",
              "textColor": "#ffffff",
              "size": 12,
              "action": "Action Object"
            ]
          ]
        ]
      ]
    ]
    
    let template = Template()
    template.assignObject(templateObject)
    
    
    templateView.layoutView(template)
    view.addSubview(templateView)
    
    view.addConstraint(NSLayoutConstraint(item: templateView, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: templateView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: templateView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
  }
}

