
import UIKit
import SDWebImage

class ButtonTemplateCell: TemplateCell {
  
  @IBOutlet weak var button: UIButton!
  var unpressedBackgroundColor: UIColor?
  var pressedBackgroundColor: UIColor?
  
  override func configureCell(template: Template, forCalculateHeight: Bool) {
    super.configureCell(template, forCalculateHeight: forCalculateHeight)
    button.setTitle(template.content.text, forState: .Normal)
    button.setTitleColor(template.content.textColor, forState: .Normal)
    button.setTitleColor(template.content.pressedTextColor, forState: .Highlighted)
    if let textSize = template.content.textSize {
      button.titleLabel?.font = UIFont.systemFontOfSize(textSize)
    }
    button.layoutMargins = template.content.padding
    button.backgroundColor = template.content.backgroundColor
    unpressedBackgroundColor = template.content.backgroundColor
    pressedBackgroundColor = template.content.pressedBackgroundColor
    
    if let borderColor = template.content.borderColor {
      button.layer.borderColor = borderColor.CGColor
      button.layer.borderWidth = 1
    }
    
    button.sd_setBackgroundImageWithURL(template.content.backgroundImageUrl?.url(), forState: .Normal)
    button.sd_setBackgroundImageWithURL(template.content.pressedBackgroundImageUrl?.url(), forState: .Highlighted)
    templateId = template.id
  }
  
  @IBAction func buttonClicked(sender: AnyObject) { //Touch Up Inside action
    button.backgroundColor = unpressedBackgroundColor
    if let templateId = templateId {
      postNotification(kNotificationDoAction, userInfo: [kNotificationKeyTemplateId: templateId])
    }
  }
  
  @IBAction func buttonReleased(sender: AnyObject) { //Touch Down action
    if pressedBackgroundColor != nil {
      button.backgroundColor = pressedBackgroundColor
    }
  }
}
