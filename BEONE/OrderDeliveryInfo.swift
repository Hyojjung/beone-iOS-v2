
import UIKit

enum TraceDisplayType: String {
  case None
  case WebView = "webview"
}

class OrderDeliveryInfo: BaseModel {
  
  var deliveryTrackingUrl: String?
  var traceDisplayType = TraceDisplayType.None
  
  override func assignObject(data: AnyObject?) {
    if let data = data as? [String: AnyObject],
      orderDeliveryTraces = data["orderDeliveryTraces"] as? [[String: AnyObject]] {
        for orderDeliveryTrace in orderDeliveryTraces {
          if let isActive = orderDeliveryTrace["isActive"] as? Bool {
            if isActive {
              deliveryTrackingUrl = orderDeliveryTrace["deliveryTrackingUrl"] as? String
              if let traceDisplayTypeString = orderDeliveryTrace["traceDisplayType"] as? String,
                traceDisplayType = TraceDisplayType(rawValue: traceDisplayTypeString) {
                  self.traceDisplayType = traceDisplayType
              }
              break
            }
          }
        }
    }
  }
}
