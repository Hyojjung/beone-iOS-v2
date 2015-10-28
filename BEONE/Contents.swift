//
//  BaseContents.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 28..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

let kContentsPropertyKeyBackgroundColor = "backgroundColor"
let kContentsPropertyKeyTextColor = "textColor"
let kContentsPropertyKeyAlignment = "alignment"
let kContentsPropertyKeyText = "text"
let kContentsPropertyKeyUnderlined = "underlined"
let kContentsPropertyKeyBold = "bold"
let kContentsPropertyKeyItalic = "italic"
let kContentsPropertyKeyCancel = "cancel"
let kContentsPropertyKeySize = "size"
let kContentsPropertyKeyImageUrl = "imageUrl"

enum ActionType: Int {
  case None = 1
  case Scheme
  case Webview
}

class Contents: BaseModel {
  var action: ActionType?
  
  var text: String?
  var alignment: Alignment?
  var underlined: Bool?
  var bold: Bool?
  var italic: Bool?
  var cancel: Bool?
  var backgroundColor: UIColor?
  var textColor: UIColor?
  var size: CGFloat?
  var imageUrl: String?
  var model: BaseModel?
  
  // MARK: - Override Methods
  
  override func assignObject(data: AnyObject) {
    if let contents = data as? [String: AnyObject] {
      // TODO: - Assign Actions
      // TODO: - Assign Model
      
      text = contents[kContentsPropertyKeyText] as? String
      imageUrl = contents[kContentsPropertyKeyImageUrl] as? String
      
      underlined = contents[kContentsPropertyKeyUnderlined] as? Bool
      bold = contents[kContentsPropertyKeyBold] as? Bool
      italic = contents[kContentsPropertyKeyItalic] as? Bool
      cancel = contents[kContentsPropertyKeyCancel] as? Bool
      
      size = contents[kContentsPropertyKeySize] as? CGFloat
      
      if let backgroundColor = contents[kContentsPropertyKeyBackgroundColor] as? String {
        self.backgroundColor = UIColor(rgba: backgroundColor)
      }
      
      if let textColor = contents[kContentsPropertyKeyTextColor] as? String {
        self.textColor = UIColor(rgba: textColor)
      }
      
      if let alignment = contents[kContentsPropertyKeyAlignment] as? Int {
        self.alignment = Alignment(rawValue: alignment)
      }
    }
  }
}
