
import UIKit

enum InquiryStatus: String {
  case Waiting = "waiting"
  case Answered = "answered"
  case Blind = "blind"
  case BlindRequesting = "blindRequesting"
}

class Inquiry: BaseModel {

  var content: String?
  var userEmail: String?
  var answer: String?
  var shopName: String?
  var status: InquiryStatus?
  var userId: Int?
  var productId: Int?
  
  override func assignObject(data: AnyObject) {
    if let inquiry = data as? [String: AnyObject] {
      id = inquiry[kObjectPropertyKeyId] as? Int
      userId = inquiry["userId"] as? Int
      content = inquiry["content"] as? String
      answer = inquiry["answer"] as? String
      if let inquiryStatusString = inquiry["inquiryStatus"] as? String,
        inquiryStatus = InquiryStatus(rawValue: inquiryStatusString) {
        status = inquiryStatus
      }
      if let user = inquiry["user"] as? [String: AnyObject] {
        userEmail = user["email"] as? String
      }
    }
  }
  
  override func deleteUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\(MyInfo.sharedMyInfo().userId!)/inquiries/\(id!)"
    }
    return "users/inquiries"
  }
  
  override func postUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\(MyInfo.sharedMyInfo().userId!)/inquiries"
    }
    return "users/inquiries"
  }
  
  override func postParameter() -> AnyObject? {
    var parameter = [String: AnyObject]()
    parameter["content"] = content
    parameter["productId"] = productId
    return parameter
  }
  
  override func putUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\(MyInfo.sharedMyInfo().userId!)/inquiries/\(id!)"
    }
    return "users/inquiries"
  }
  
  override func putParameter() -> AnyObject? {
    var parameter = [String: AnyObject]()
    parameter["content"] = content
    return parameter
  }
}
