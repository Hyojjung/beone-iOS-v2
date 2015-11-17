//
//  DeviceInfo.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 16..
//  Copyright © 2015년 효정 김. All rights reserved.
//

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
  
  override func fetchUrl() -> String {
    return url()
  }
  
  override func fetchSuccess() -> NetworkSuccess? {
    return {(result) -> Void in
      if let result = result as? [String: AnyObject], data = result[kNetworkResponseKeyData] as? [String: AnyObject] {
        self.isReceivingPush = data[kDeviceInfoPropertyKeyIsReceivingPush]?.boolValue == true ? true : false
        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationFetchDeviceInfoSuccess, object: nil)
      }
    }
  }
  
  override func putUrl() -> String {
    return url()
  }
  
  override func putParameter() -> AnyObject? {
    return [kDeviceInfoPropertyKeyIsReceivingPush: isReceivingPush]
  }
  
  override func putSuccess() -> NetworkSuccess? {
    return {(result) -> Void in
      self.fetch()
    }
  }
  
  override func putFailure() -> NetworkFailure? {
    return {(error) -> Void in
      self.fetch()
    }
  }
}
