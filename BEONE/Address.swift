//
//  Address.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 20..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class Address: BaseModel {
  private let kAddressPropertyKeyName = "receiverName"
  private let kAddressPropertyKeyPhone = "receiverPhone"
  private let kAddressPropertyKeyZipCode1 = "receiverZipcode01"
  private let kAddressPropertyKeyZipCode2 = "receiverZipcode02"
  private let kAddressPropertyKeyRoadAddress = "receiverRoadAddress"
  private let kAddressPropertyKeyJibunAddress = "receiverJibunAddress"
  private let kAddressPropertyKeyAddressType = "receiverAddressType"
  private let kAddressPropertyKeyDetailAddress = "receiverDetailAddress"
  private let kAddressPropertyKeyDeliveryPoint = "deliveryPoint"
  private let kAddressPropertyKeyReceiverZonecode = "receiverZonecode"
  
  enum ReceiverAddressType: String {
    case Road = "R"
    case Jibun = "J"
  }
  
  var receiverName: String?
  var receiverPhone: String?
  var receiverZipcode01: String?
  var receiverZipcode02: String?
  var zonecode: String?
  var receiverRoadAddress: String?
  var receiverJibunAddress: String?
  var receiverDetailAddress: String?
  var receiverAddressType: String?
  
  override func assignObject(data: AnyObject) {
    print(data)
  }
}
