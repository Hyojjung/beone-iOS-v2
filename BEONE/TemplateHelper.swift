
import UIKit

let kShopContentsViewViewNibName = "ShopContentsView"

class TemplateHelper: NSObject {
  static func viewNibName(type: TemplateType) -> String? {
    switch type {
    case .Text:
      return "TextContentsView"
    case .Image:
      return "ImageContentsView"
    case .Button:
      return "ButtonContentsView"
    case .Gap:
      return "GapContentsView"
    case .Shop:
      return kShopContentsViewViewNibName
    case .Product:
      return "ProductContentsView"
    case .Review:
      return "ReviewContentsView"
    case .Banner:
      return "BannerContentsView"
    case .Table:
      return "TableContentsView"
    }
  }
}

extension String {
  func edgeInsets() -> UIEdgeInsets {
    let insetStrings = componentsSeparatedByString(" ")
    if insetStrings.count == 1 {
      let insets = [insetStrings[0], insetStrings[0], insetStrings[0], insetStrings[0]]
      return UIEdgeInsetsFromString("{\(insets.joinWithSeparator(","))}")
    } else if insetStrings.count == 2 {
      let insets = [insetStrings[0], insetStrings[1], insetStrings[0], insetStrings[1]]
      return UIEdgeInsetsFromString("{\(insets.joinWithSeparator(","))}")
    } else if insetStrings.count == 4 {
      let insets = [insetStrings[0], insetStrings[3], insetStrings[2], insetStrings[1]]
      return UIEdgeInsetsFromString("{\(insets.joinWithSeparator(","))}")
    }
    return UIEdgeInsetsZero
  }
}