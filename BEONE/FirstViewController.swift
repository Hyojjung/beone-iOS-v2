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
              "action": [
                "type": "none"
              ]
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
              "imageUrl": "/resources/images/banners/banner_intro.jpg",
              "action": [
                "type": "webview",
                "content": "http://cmlatte.com"
              ]
            ]
          ]
        ],
        [
          "type": "table",
          "style":  [
            "margin": "11 24 13 20",
            "padding": "25 10 2 9",
            "backgroundColor": "#df345f",
            "backgroundImageUrl": "",
            "alignment": "center"
          ],
          "hasSpace": true,
          "row": 4,
          "col": 3,
          "contents": [
            [
              "backgroundImageUrl": "/resources/images/products/candlysophie/07.jpg",
              "textColor": "#92d730",
              "text": "String",
              "action": [
                "type": "webview",
                "content": "http://cmlatte.com"
              ]            ],[
              "backgroundImageUrl": "/resources/images/products/candlysophie/07.jpg",
              "textColor": "#92d730",
              "text": "String",
                "action": [
                  "type": "none"
                ]
            ],[
              "backgroundImageUrl": "/resources/images/products/candlysophie/07.jpg",
              "textColor": "#927030",
              "text": "String",
              "action": "Action Object"
            ],[
              "backgroundImageUrl": "/resources/images/products/candlysophie/07.jpg",
              "textColor": "#927340",
              "text": "String",
              "action": "Action Object"
            ],[
              "backgroundImageUrl": "/resources/images/products/candlysophie/07.jpg",
              "textColor": "#927d30",
              "text": "String",
              "action": "Action Object"
            ],[
              "backgroundImageUrl": "/resources/images/products/candlysophie/07.jpg",
              "textColor": "#9273f0",
              "text": "String",
              "action": "Action Object"
            ],[
              "backgroundImageUrl": "/resources/images/products/candlysophie/07.jpg",
              "textColor": "#922730",
              "text": "String",
              "action": "Action Object"
            ],[
              "backgroundImageUrl": "/resources/images/products/candlysophie/07.jpg",
              "textColor": "#927430",
              "text": "String",
              "action": "Action Object"
            ]
          ]
        ]
      ]
    ]
    
    let template = Template()
    template.assignObject(templateObject)
    
    
    templateView.layoutView(template)
    scrollView.addSubview(templateView)
    
    scrollView.addConstraint(NSLayoutConstraint(item: templateView, attribute: .Top, relatedBy: .Equal, toItem: scrollView, attribute: .Top, multiplier: 1, constant: 0))
    scrollView.addConstraint(NSLayoutConstraint(item: templateView, attribute: .Bottom, relatedBy: .Equal, toItem: scrollView, attribute: .Bottom, multiplier: 1, constant: 0))
    scrollView.addConstraint(NSLayoutConstraint(item: templateView, attribute: .Left, relatedBy: .Equal, toItem: scrollView, attribute: .Left, multiplier: 1, constant: 0))
    scrollView.addConstraint(NSLayoutConstraint(item: templateView, attribute: .Right, relatedBy: .Equal, toItem: scrollView, attribute: .Right, multiplier: 1, constant: 0))
    scrollView.addConstraint(NSLayoutConstraint(item: templateView, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1, constant: 0))
  }
}

