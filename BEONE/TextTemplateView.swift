//
//  ImageTemplateView.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 28..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class TextTemplateView: UIView {
  
  @IBOutlet weak var textLabel: UILabel!
  
  func layoutView(contents: Contents) {
    if let text = contents.text {
      print(contents.alignment)
      if let alignment = contents.alignment {
        switch alignment {
        case .Left:
          textLabel.textAlignment = .Left
        case .Center:
          textLabel.textAlignment = .Center
        case .Right:
          textLabel.textAlignment = .Right
        }
      }
      
      let attributedString = NSMutableAttributedString(string: text)
      
      if contents.isUnderlined != nil && contents.isUnderlined! {
        attributedString.addAttribute(NSUnderlineStyleAttributeName,
          value: NSUnderlineStyle.StyleSingle.rawValue,
          range: NSMakeRange(0, text.characters.count))
      }
      if contents.isCancelLined != nil && contents.isCancelLined! {
        attributedString.addAttribute(NSStrikethroughStyleAttributeName,
          value: NSUnderlineStyle.StyleSingle.rawValue,
          range: NSMakeRange(0, text.characters.count))
      }
      if let backgroundColor = contents.backgroundColor {
        attributedString.addAttribute(NSBackgroundColorAttributeName,
          value: backgroundColor,
          range: NSMakeRange(0, text.characters.count))
      }
      if let textColor = contents.textColor {
        attributedString.addAttribute(NSForegroundColorAttributeName,
          value: textColor,
          range: NSMakeRange(0, text.characters.count))
      }
      
      if let size = contents.size, isBold = contents.isBold, isItalic = contents.isItalic {
        let fontName: String
        if isBold && isItalic {
          fontName = "HelveticaNeue-BoldItalic"
        } else if isBold && !isItalic {
          fontName = "HelveticaNeue-Bold"
        } else if !isBold && isItalic {
          fontName = "HelveticaNeue-Italic"
        } else {
          fontName = "HelveticaNeue"
        }
        attributedString.addAttribute(NSFontAttributeName,
          value: UIFont(name: fontName, size: size)!,
          range: NSMakeRange(0, text.characters.count))
      }
      
      textLabel.attributedText = attributedString
    }
  }
}