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
let kContentsPropertyKeyIsUnderlined = "isUnderlined"
let kContentsPropertyKeyIsBold = "isBold"
let kContentsPropertyKeyIsItalic = "isItalic"
let kContentsPropertyKeyIsCancelLined = "isCancelLined"
let kContentsPropertyKeySize = "size"
let kContentsPropertyKeyImageUrl = "imageUrl"
let kContentsPropertyKeyBackgroundImageUrl = "backgroundImageUrl"
let kContentsPropertyKeyAction = "action"

enum Alignment: String {
  case Left = "left"
  case Center = "center"
  case Right = "right"
}

class Contents: BaseModel {
  var action = Action()
  
  var text: String?
  var alignment: Alignment?
  var isUnderlined: Bool?
  var isBold: Bool?
  var isItalic: Bool?
  var isCancelLined: Bool?
  var backgroundColor: UIColor?
  var textColor: UIColor?
  var size: CGFloat?
  var imageUrl: String?
  var backgroundImageUrl: String?
  var model: BaseModel?
  
  // MARK: - Override Methods
  
  override func assignObject(data: AnyObject) {
    if let contents = data as? [String: AnyObject] {
      // TODO: - Assign Model
      text = contents[kContentsPropertyKeyText] as? String
      imageUrl = contents[kContentsPropertyKeyImageUrl] as? String
      backgroundImageUrl = contents[kContentsPropertyKeyBackgroundImageUrl] as? String
      isUnderlined = contents[kContentsPropertyKeyIsUnderlined] as? Bool
      isBold = contents[kContentsPropertyKeyIsBold] as? Bool
      isItalic = contents[kContentsPropertyKeyIsItalic] as? Bool
      isCancelLined = contents[kContentsPropertyKeyIsCancelLined] as? Bool
      size = contents[kContentsPropertyKeySize] as? CGFloat
      if let backgroundColor = contents[kContentsPropertyKeyBackgroundColor] as? String {
        self.backgroundColor = UIColor(rgba: backgroundColor)
      }
      if let action = contents[kContentsPropertyKeyAction] {
        self.action.assignObject(action)
      }
      if let textColor = contents[kContentsPropertyKeyTextColor] as? String {
        self.textColor = UIColor(rgba: textColor)
      }
      if let alignment = contents[kContentsPropertyKeyAlignment] as? String {
        self.alignment = Alignment(rawValue: alignment)
      }
    }
  }
}
