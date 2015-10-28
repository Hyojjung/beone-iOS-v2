//
//  TemplateStyle.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 28..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

let kTemplateStylePropertyKeyMargin = "margin"
let kTemplateStylePropertyKeyPadding = "padding"
let kTemplateStylePropertyKeyBackgroundColor = "backgroundColor"
let kTemplateStylePropertyKeyBackgroundImageUrl = "backgroundImageUrl"
let kTemplateStylePropertyKeyAlignment = "alignment"

enum Alignment: Int {
  case Left = 1
  case Center
  case Right
}

class TemplateStyle: BaseModel {
  var margin: UIEdgeInsets?
  var padding: UIEdgeInsets?
  var backgroundColor: UIColor?
  var backgroundImageUrl: String?
  var alignment: Alignment?
  
  // MARK: - Override Methods
  
  override func assignObject(data: AnyObject) {
    if let style = data as? [String: AnyObject] {
      if let margin = style[kTemplateStylePropertyKeyMargin] as? String {
        let marginString = "{\(margin.stringByReplacingOccurrencesOfString(" ", withString: ","))}"
        self.margin = UIEdgeInsetsFromString(marginString)
      }
      
      if let padding = style[kTemplateStylePropertyKeyPadding] as? String {
        let paddingString = "{\(padding.stringByReplacingOccurrencesOfString(" ", withString: ","))}"
        self.padding = UIEdgeInsetsFromString(paddingString)
      }
      
      if let backgroundColor = style[kTemplateStylePropertyKeyBackgroundColor] as? String {
        self.backgroundColor = UIColor(rgba: backgroundColor)
      }
      
      backgroundImageUrl = style[kTemplateStylePropertyKeyBackgroundImageUrl] as? String
      
      if let alignment = style[kTemplateStylePropertyKeyAlignment] as? Int {
        self.alignment = Alignment(rawValue: alignment)
      }
    }
  }

}
