
import UIKit
import SDWebImage

class ButtonTemplateCell: TemplateCell {
  
  @IBOutlet weak var button: UIButton!
  var unpressedBackgroundColor: UIColor?
  var pressedBackgroundColor: UIColor?
  
  override func configureCell(template: Template) {
    super.configureCell(template)
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
  
  override func calculatedHeight(template: Template) -> CGFloat? {
    if let height = template.height {
      return height
    } else {
      var height: CGFloat = 0
      height += template.style.margin.top + template.style.margin.bottom
      height += template.style.padding.top + template.style.padding.bottom
      
      let button = UIButton()
      if let textSize = template.content.textSize {
        button.titleLabel?.font = UIFont.systemFontOfSize(textSize)
      }
      button.layoutMargins = template.content.padding
      if template.content.borderColor != nil{
        button.layer.borderWidth = 1
      }
      button.sizeToFit()
      
      height += button.frame.height
      template.height = height
      return height
    }
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
