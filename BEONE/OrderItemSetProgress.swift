
import UIKit

enum ProgressType: String {
  case Waiting = "waiting"
  case Progressing = "progressing"
  case Done = "done"
}

class OrderItemSetProgress: BaseModel {
  var name: String?
  var progressType: ProgressType?
  var progressedAt: String?
  var progressStatus = ProgressType.Waiting
  
  override func assignObject(data: AnyObject) {
    if let data = data as? [String: AnyObject] {
      name = data["name"] as? String
      if let progressTypeString = data["progressType"] as? String,
        progressType = ProgressType(rawValue: progressTypeString) {
        self.progressType = progressType
      }
      if let progressedAt = data["progressedAt"] as? String {
          self.progressedAt = progressedAt.date()?.orderItemSetProgressedAt()
      }
    }
  }
}
