
import UIKit
import SDWebImage

class ButtonTemplateCell: TemplateCell {
  
  @IBOutlet weak var button: UIButton!
  
  override func configureCell(template: Template) {
    super.configureCell(template)
    
    button.setTitle(template.content.text, forState: .Normal)
    button.setTitle(template.content.text, forState: .Highlighted)
    
    button.setTitleColor(template.content.textColor, forState: .Normal)
    if let pressedTextColor = template.content.pressedTextColor {
      button.setTitleColor(pressedTextColor, forState: .Highlighted)
    } else {
      button.setTitleColor(template.content.textColor, forState: .Highlighted)
    }
    
    if let textSize = template.content.textSize {
      button.titleLabel?.font = UIFont.systemFontOfSize(textSize)
    }
    
    button.contentEdgeInsets = template.content.padding
    button.backgroundColor = template.content.backgroundColor
    
    if template.content.backgroundColor != nil && template.content.backgroundImageUrl == nil {
      let backgroundColorImage = template.content.backgroundColor?.imageWithColor()
      button.setBackgroundImage(backgroundColorImage, forState: .Normal)
    } else if let backgroundImageUrl = template.content.backgroundImageUrl {
      button.sd_setBackgroundImageWithURL(backgroundImageUrl.url(), forState: .Normal)
    } else {
      button.backgroundColor = UIColor.clearColor()
    }
    
    if template.content.pressedBackgroundColor != nil && template.content.pressedBackgroundImageUrl == nil {
      let pressedBackgroundColorImage = template.content.pressedBackgroundColor?.imageWithColor()
      button.setBackgroundImage(pressedBackgroundColorImage, forState: .Highlighted)
    } else if let pressedBackgroundImageUrl = template.content.pressedBackgroundImageUrl {
      button.sd_setBackgroundImageWithURL(pressedBackgroundImageUrl.url(), forState: .Normal)
    }
    
    button.sd_setImageWithURL(template.content.imageUrl?.url(), forState: .Normal)
    
    if let borderColor = template.content.borderColor {
      button.layer.borderColor = borderColor.CGColor
      button.layer.borderWidth = 1
    }
    
    templateId = template.id
  }
  
  @IBAction func buttonClicked(sender: AnyObject) {
    action?.action()
  }
  

}
