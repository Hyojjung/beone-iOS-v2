
import UIKit

let kDefaultCountPerPage = 20

class BaseListModel: BaseModel {
  var count: Int?
  var total = 0
  var page: Int?
  var list = [BaseModel]()
  var title: String?
  
  override func get(getSuccess: (() -> Void)? = nil) {
    NetworkHelper.requestGet(getUrl(), parameter: getParameter(), success: { (result) -> Void in
      if let result = result as? [String: AnyObject] {
        if let meta = result["meta"] as? [String: AnyObject] {
          self.title = meta["title"] as? String
          if let total = meta["total"] as? Int {
            self.total = total
          }
          if let count = meta["count"] as? Int {
            self.count = count
          }
          if let page = meta["page"] as? Int {
            self.page = page
          }
        }
        self.assignObject(result[kNetworkResponseKeyData])
      }
      getSuccess?()
      }, failure: nil)
  }
  
  func needFetch(index: Int) -> Bool {
    if let count = count {
      if count < total && index / kDefaultCountPerPage == 0 && count == index {
        return true
      }
    }
    return false
  }
  
  func model(id: Int?) -> BaseModel? {
    for model in list {
      if model.id == id {
        return model
      }
    }
    return nil
  }
  
  func indexOfModel(with id: Int) -> Int? {
    for (index, object) in list.enumerate() {
      if object.id == id {
        return index
      }
    }
    return nil
  }
}