//
//  ImageTemplateView.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 28..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class TextContentsView: TemplateContentsView {
  @IBOutlet weak var textLabel: UILabel!
  var action: Action?

  // MARK: - Override Methods

  override func layoutView(template: Template) {
    if let textContents = template.contents.first, text = textContents.text {
      action = textContents.action
      if let alignment = textContents.alignment {
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
      if textContents.isUnderlined != nil && textContents.isUnderlined! {
        attributedString.addAttribute(NSUnderlineStyleAttributeName,
          value: NSUnderlineStyle.StyleSingle.rawValue,
          range: NSMakeRange(0, text.characters.count))
      }
      if textContents.isCancelLined != nil && textContents.isCancelLined! {
        attributedString.addAttribute(NSStrikethroughStyleAttributeName,
          value: NSUnderlineStyle.StyleSingle.rawValue,
          range: NSMakeRange(0, text.characters.count))
      }
      if let backgroundColor = textContents.backgroundColor {
        attributedString.addAttribute(NSBackgroundColorAttributeName,
          value: backgroundColor,
          range: NSMakeRange(0, text.characters.count))
      }
      if let textColor = textContents.textColor {
        attributedString.addAttribute(NSForegroundColorAttributeName,
          value: textColor,
          range: NSMakeRange(0, text.characters.count))
      }
      
      if let size = textContents.size, isBold = textContents.isBold, isItalic = textContents.isItalic {
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
  
  // MARK: - Actions
  
  @IBAction func viewTapped() {
    action?.action()
  }
}