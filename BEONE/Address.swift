//
//  Address.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 20..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

enum AddressType: String {
  case Road = "R"
  case Jibun = "J"
}

let kAddressPropertyKeyName = "receiverName"
let kAddressPropertyKeyPhone = "receiverPhone"
let kAddressPropertyKeyZipCode1 = "receiverZipcode01"
let kAddressPropertyKeyZipCode2 = "receiverZipcode02"
let kAddressPropertyKeyRoadAddress = "receiverRoadAddress"
let kAddressPropertyKeyJibunAddress = "receiverJibunAddress"
let kAddressPropertyKeyAddressType = "receiverAddressType"
let kAddressPropertyKeyDetailAddress = "receiverDetailAddress"
let kAddressPropertyKeyDeliveryPoint = "deliveryPoint"
let kAddressPropertyKeyReceiverZonecode = "receiverZonecode"
let kAddressPropertyKeyUserSelectedType = "userSelectedType"

class Address: BaseModel {
  var receiverName: String?
  var receiverPhone: String?
  var zipcode01: String?
  var zipcode02: String?
  var zonecode: String?
  var roadAddress: String?
  var jibunAddress: String?
  var detailAddress: String?
  var buildingName: String?
  var addressType: AddressType?
  
  override func assignObject(data: AnyObject) {
    if let address = data as? [String: AnyObject] {
      if let userSelectedType = address[kAddressPropertyKeyUserSelectedType] as? String {
        addressType = AddressType(rawValue: userSelectedType)
      }
      zipcode01 = address["postcode1"] as? String
      zipcode02 = address["postcode2"] as? String
      zonecode = address["zonecode"] as? String
      roadAddress = address["roadAddress"] as? String
      jibunAddress = address["jibunAddress"] as? String
      buildingName = address["buildingName"] as? String
    }
  }
}
