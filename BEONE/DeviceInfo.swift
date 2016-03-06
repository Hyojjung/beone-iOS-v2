
import UIKit

let kDeviceInfoPropertyKeyIsReceivingPush = "isReceivingPush"

class DeviceInfo: BaseModel {
  
  var isReceivingPush = false
  
  private func url() -> String {
    if let deviceInfoId = MyInfo.sharedMyInfo().userDeviceInfoId {
      return "device-infos/\(deviceInfoId)"
    }
    return "device-infos"
  }
  
  override func getUrl() -> String {
    return url()
  }
  
  override func assignObject(data: AnyObject?) {
    if let data = data as? [String: AnyObject] {
      self.isReceivingPush = data[kDeviceInfoPropertyKeyIsReceivingPush]?.boolValue == true ? true : false
    }
  }
  
  override func putUrl() -> String {
    return url()
  }
  
  override func putParameter() -> AnyObject? {
    return [kDeviceInfoPropertyKeyIsReceivingPush: isReceivingPush]
  }
}
