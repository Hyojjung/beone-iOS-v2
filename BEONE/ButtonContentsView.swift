
import UIKit
import SDWebImage

class ButtonContentsView: TemplateContentsView {
  @IBOutlet weak var button: UIButton!
  var unpressedBackgroundColor: UIColor?
  var pressedBackgroundColor: UIColor?
  
  override func layoutView(template: Template) {
    if let buttonContents = template.contents.first {
      button.setTitle(buttonContents.text, forState: .Normal)
      button.setTitleColor(buttonContents.textColor, forState: .Normal)
      button.setTitleColor(buttonContents.pressedTextColor, forState: .Highlighted)
      button.backgroundColor = buttonContents.backgroundColor
      unpressedBackgroundColor = buttonContents.backgroundColor
      pressedBackgroundColor = buttonContents.pressedBackgroundColor
      
      if let borderColor = buttonContents.borderColor {
        button.layer.borderColor = borderColor.CGColor
        button.layer.borderWidth = 1
      }
      
      button.sd_setBackgroundImageWithURL(buttonContents.backgroundImageUrl?.url(), forState: .Normal)
      button.sd_setBackgroundImageWithURL(buttonContents.pressedBackgroundImageUrl?.url(), forState: .Highlighted)
    }
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
