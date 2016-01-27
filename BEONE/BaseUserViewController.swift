

import UIKit

class BaseUserViewController: BaseTableViewController {

  var isWaitingSigning = false

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if !MyInfo.sharedMyInfo().isUser() {
      if isWaitingSigning {
        popView()
      } else {
        isWaitingSigning = true
        showSigningView()
      }
    }
  }
}
