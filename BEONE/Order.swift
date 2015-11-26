
import UIKit

class Order: BaseModel {
  var senderName: String?
  var senderPhone: String?
  var isSecret: Bool?
  var address: Address?
  var deliveryMemo: String?
}
