
import UIKit

let kDefaultTextSize = CGFloat(14)

class TextTemplateCell: TemplateCell {
  
  @IBOutlet weak var label: UILabel!
  
  // MARK: - Override Methods
  
  override func configureCell(template: Template) {
    super.configureCell(template)
    if let text = template.content.text {
      let attributedString = NSMutableAttributedString(string: text)
        configureBackgroundColor(attributedString, textContent: template.content)
        configureTextColor(attributedString, textContent: template.content)
      configureLabelAlignment(template.content)
      configureUnderlined(attributedString, textContent: template.content)
      configureCancelLined(attributedString, textContent: template.content)
      configureFontAndSize(attributedString, textContent: template.content)
      label.attributedText = attributedString
    }
    templateId = template.id
  }
  
  override func calculatedHeight(template: Template) -> CGFloat {
    var height: CGFloat = 0
    height += template.style.margin.top + template.style.margin.bottom
    height += template.style.padding.top + template.style.padding.bottom
    
    let label = UILabel()
    if let size = template.content.size {
      label.font = UIFont.systemFontOfSize(size)
    }
    label.text = template.content.text
    
    let width = ViewControllerHelper.screenWidth -
      (template.style.margin.left + template.style.margin.right +
        template.style.padding.left + template.style.padding.right)
    label.setWidth(width)

    height += label.frame.height
    return height
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
        self.label.textAlignment = .Left
      case .Center:
        self.label.textAlignment = .Center
      case .Right:
        self.label.textAlignment = .Right
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