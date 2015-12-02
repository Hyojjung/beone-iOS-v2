
import UIKit

let kDefaultTextSize = CGFloat(14)

class TextContentsView: TemplateContentsView {
  
  @IBOutlet weak var textLabel: UILabel!
  
  // MARK: - Override Methods
  
  override func className() -> String {
    return "Text"
  }
  
  override func layoutView(template: Template) {
    if let text = template.content.text {
      configureLabelAlignment(template.content)
      
      let attributedString = NSMutableAttributedString(string: text)
      configureUnderlined(attributedString, textContent: template.content)
      configureCancelLined(attributedString, textContent: template.content)
      configureBackgroundColor(attributedString, textContent: template.content)
      configureTextColor(attributedString, textContent: template.content)
      configureFontAndSize(attributedString, textContent: template.content)
      textLabel.attributedText = attributedString
    }
    templateId = template.id
  }
  
  // MARK: - Actions
  
  @IBAction func viewTapped() {
    if let templateId = templateId {
      postNotification(kNotificationDoAction, userInfo: [kNotificationKeyTemplateId: templateId])
    }
  }
  
  // MARK: - Private Methods
  
  private func configureLabelAlignment(textContents: Content?) {
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
  
  private func configureFontAndSize(attributedString: NSMutableAttributedString, textContent: Content?) {
    checkTextContents(textContent) { (textContents, text) -> Void in
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
  
  private func configureUnderlined(attributedString: NSMutableAttributedString, textContent: Content?) {
    checkTextContents(textContent) { (textContents, text) -> Void in
      if textContents.isUnderlined != nil && textContents.isUnderlined! {
        attributedString.addAttribute(NSUnderlineStyleAttributeName,
          value: NSUnderlineStyle.StyleSingle.rawValue,
          range: NSMakeRange(0, text.characters.count))
      }
    }
  }
  
  private func configureCancelLined(attributedString: NSMutableAttributedString, textContent: Content?) {
    checkTextContents(textContent) { (textContents, text) -> Void in
      if textContents.isCancelLined != nil && textContents.isCancelLined! {
        attributedString.addAttribute(NSStrikethroughStyleAttributeName,
          value: NSUnderlineStyle.StyleSingle.rawValue,
          range: NSMakeRange(0, text.characters.count))
      }
    }
  }
  
  private func configureBackgroundColor(attributedString: NSMutableAttributedString, textContent: Content?) {
    checkTextContents(textContent) { (textContents, text) -> Void in
      if let backgroundColor = textContents.backgroundColor {
        attributedString.addAttribute(NSBackgroundColorAttributeName,
          value: backgroundColor,
          range: NSMakeRange(0, text.characters.count))
      }
    }
  }
  
  private func configureTextColor(attributedString: NSMutableAttributedString, textContent: Content?) {
    checkTextContents(textContent) { (textContents, text) -> Void in
      if let textColor = textContents.textColor {
        attributedString.addAttribute(NSForegroundColorAttributeName,
          value: textColor,
          range: NSMakeRange(0, text.characters.count))
      }
    }
  }
  
  private func checkTextContents(textContent: Content?, ifTextContent: (Content, String) -> Void) {
    if let textContent = textContent, text = textContent.text {
      ifTextContent(textContent, text)
    }
  }
}