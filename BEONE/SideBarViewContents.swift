
import UIKit

class SideBarViewContents: BaseModel {
  override func fetchUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\(MyInfo.sharedMyInfo().userId!)/sidebar"
    } else {
      return "users"
    }
  }
}
