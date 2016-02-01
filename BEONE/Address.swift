
import UIKit

enum AddressType: String {
  case Road = "R"
  case Jibun = "J"
}

let kAddressPropertyKeyName = "receiverName"
let kAddressPropertyKeyPhone = "receiverPhone"
let kAddressPropertyKeyZipCode1 = "receiverZipcode01"
let kAddressPropertyKeyZipCode2 = "receiverZipcode02"
let kAddressPropertyKeyReceiverRoadAddress = "receiverRoadAddress"
let kAddressPropertyKeyReceiverJibunAddress = "receiverJibunAddress"
let kAddressPropertyKeyAddressType = "receiverAddressType"
let kAddressPropertyKeyDetailAddress = "receiverDetailAddress"
let kAddressPropertyKeyDeliveryPoint = "deliveryPoint"
let kAddressPropertyKeyReceiverZonecode = "receiverZonecode"
let kAddressPropertyKeyReceiverAddressType = "receiverAddressType"
let kAddressPropertyReceiverAddressTypeRoad = "road"
let kAddressPropertyReceiverAddressTypeJibun = "jibun"

let kAddressPropertyKeyUserSelectedType = "userSelectedType"
let kAddressPropertyKeyPostcode1 = "postcode1"
let kAddressPropertyKeyPostcode2 = "postcode2"
let kAddressPropertyKeyZonecode = "zonecode"
let kAddressPropertyKeyRoadAddress = "roadAddress"
let kAddressPropertyKeyJibunAddress = "jibunAddress"
let kAddressPropertyKeyBuildingName = "buildingName"

class Address: BaseModel {
  var receiverName: String?
  var receiverPhone: String?
  var zipcode01: String?
  var zipcode02: String?
  var zonecode: String?
  var roadAddress: String?
  var jibunAddress: String?
  var detailAddress: String?
  var addressType: AddressType?
  
  override func assignObject(data: AnyObject) {
    if let address = data as? [String: AnyObject] {
      if let receiverAddressType = address[kAddressPropertyKeyReceiverAddressType] as? String {
        addressType = receiverAddressType == kAddressPropertyReceiverAddressTypeRoad ? .Road : .Jibun
      }
      zipcode01 = address[kAddressPropertyKeyZipCode1] as? String
      zipcode02 = address[kAddressPropertyKeyZipCode2] as? String
      zonecode = address[kAddressPropertyKeyReceiverZonecode] as? String
      roadAddress = address[kAddressPropertyKeyReceiverRoadAddress] as? String
      jibunAddress = address[kAddressPropertyKeyReceiverJibunAddress] as? String
      detailAddress = address[kAddressPropertyKeyDetailAddress] as? String
      receiverName = address[kAddressPropertyKeyName] as? String
      receiverPhone = address[kAddressPropertyKeyPhone] as? String
    }
  }
  
  func assign(address: [String: String]) {
    if let userSelectedType = address[kAddressPropertyKeyUserSelectedType] {
      addressType = AddressType(rawValue: userSelectedType)
    }
    zipcode01 = address[kAddressPropertyKeyPostcode1]
    zipcode02 = address[kAddressPropertyKeyPostcode2]
    zonecode = address[kAddressPropertyKeyZonecode]
    roadAddress = address[kAddressPropertyKeyRoadAddress]
    jibunAddress = address[kAddressPropertyKeyJibunAddress]
    
    if let buildingName = address[kAddressPropertyKeyBuildingName], roadAddress = roadAddress, jibunAddress = jibunAddress {
      if !buildingName.isEmpty {
        self.roadAddress = "\(roadAddress) (\(buildingName))"
        self.jibunAddress = "\(jibunAddress) (\(buildingName))"
      }
    }
  }
  
  func zipCode() -> String? {
    if let zonecode = zonecode {
      return zonecode
    } else if let zipcode01 = zipcode01, zipcode02 = zipcode02 {
      return zipcode01 + zipcode02
    }
    return nil
  }
  
  func fullAddressString(splitLine: Bool = false) -> String? {
    if let address = addressString() {
      if let detailAddress = detailAddress {
        if splitLine {
          return address + "\n" + detailAddress
        }
        return address + detailAddress
      }
      return address
    }
    return nil
  }
  
  func addressString() -> String? {
    if addressType == .Road {
      return roadAddress
    } else {
      return jibunAddress
    }
  }
}
