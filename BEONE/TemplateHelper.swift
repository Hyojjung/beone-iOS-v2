
import UIKit

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
      return "ShopContentsView"
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
    return UIEdgeInsetsFromString("{\(stringByReplacingOccurrencesOfString(" ", withString: ","))}")
  }
}