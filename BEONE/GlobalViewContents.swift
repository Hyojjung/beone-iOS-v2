
import UIKit

class GlobalViewContents: BaseModel {
  var kakaoPlus: String?
  
  override func getUrl() -> String {
    return "app-view-data/global"
  }
  
  override func assignObject(data: AnyObject?) {
    if let globalViewContents = data as? [String: AnyObject], urlString = globalViewContents["kakaoPlus"] as? String {
      kakaoPlus = urlString.stringByAddingPercentEncodingWithAllowedCharacters(.URLFragmentAllowedCharacterSet())
    }
  }
}
