
import UIKit

let kDefaultTextSize = CGFloat(14)

class TextContentsView: TemplateContentsView {
  
  @IBOutlet weak var textLabel: UILabel!
  
  // MARK: - Override Methods
  
  override func layoutView(template: Template) {
    if let textContents = template.contents.first, text = textContents.text {
      configureLabelAlignment(textContents)
      
      let attributedString = NSMutableAttributedString(string: text)
      configureUnderlined(attributedString, textContents: textContents)
      configureCancelLined(attributedString, textContents: textContents)
      configureBackgroundColor(attributedString, textContents: textContents)
      configureTextColor(attributedString, textContents: textContents)
      configureFontAndSize(attributedString, textContents: textContents)
      textLabel.attributedText = attributedString
    }
    templateId = template.id
  }
  
  // MARK: - Actions
  
  @IBAction func viewTapped() {
    if let templateId = templateId {
      NSNotificationCenter.defaultCenter().postNotificationName(kNotificationDoAction,
        object: nil,
        userInfo: [kNotificationKeyTemplateId: templateId])
    }
  }
  
  // MARK: - Private Methods
  
  private func configureLabelAlignment(textContents: Contents?) {
    checkTextContents(textContents) { (textContents, _) -> Void in
      let alignment = textContents.alignment != nil ? textContents.alignment : Alignment.Left
      switch alignment! {
      case .Left:
        self.textLabel.textAlignment = .Left
      case .Center:
        self.textLabel.textAlignment = .Center
      case .Right:
        self.textLabel.textAlignment = .Right
      }
    }
  }
  
  private func configureFontAndSize(attributedString: NSMutableAttributedString, textContents: Contents?) {
    checkTextContents(textContents) { (textContents, text) -> Void in
      let isBold = textContents.isBold != nil && textContents.isBold!
      let isItalic = textContents.isItalic != nil && textContents.isItalic!
      let size = textContents.size != nil ? textContents.size : kDefaultTextSize
      
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
        value: UIFont(name: fontName, size: size!)!,
        range: NSMakeRange(0, text.characters.count))
    }
  }
  
  private func configureUnderlined(attributedString: NSMutableAttributedString, textContents: Contents?) {
    checkTextContents(textContents) { (textContents, text) -> Void in
      if textContents.isUnderlined != nil && textContents.isUnderlined! {
        attributedString.addAttribute(NSUnderlineStyleAttributeName,
          value: NSUnderlineStyle.StyleSingle.rawValue,
          range: NSMakeRange(0, text.characters.count))
      }
    }
  }
  
  private func configureCancelLined(attributedString: NSMutableAttributedString, textContents: Contents?) {
    checkTextContents(textContents) { (textContents, text) -> Void in
      if textContents.isCancelLined != nil && textContents.isCancelLined! {
        attributedString.addAttribute(NSStrikethroughStyleAttributeName,
          value: NSUnderlineStyle.StyleSingle.rawValue,
          range: NSMakeRange(0, text.characters.count))
      }
    }
  }
  
  private func configureBackgroundColor(attributedString: NSMutableAttributedString, textContents: Contents?) {
    checkTextContents(textContents) { (textContents, text) -> Void in
      if let backgroundColor = textContents.backgroundColor {
        attributedString.addAttribute(NSBackgroundColorAttributeName,
          value: backgroundColor,
          range: NSMakeRange(0, text.characters.count))
      }
    }
  }
  
  private func configureTextColor(attributedString: NSMutableAttributedString, textContents: Contents?) {
    checkTextContents(textContents) { (textContents, text) -> Void in
      if let textColor = textContents.textColor {
        attributedString.addAttribute(NSForegroundColorAttributeName,
          value: textColor,
          range: NSMakeRange(0, text.characters.count))
      }
    }
  }
  
  private func checkTextContents(textContents: Contents?, ifTextContents: (Contents, String) -> Void) {
    if let textContents = textContents, text = textContents.text {
      ifTextContents(textContents, text)
    }
  }
}