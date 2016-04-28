
import UIKit

enum AddressType: String {
  case Road = "road"
  case Jibun = "jibun"
  
  static func addressType(with daumApiAddressTypeNotation: String?) -> AddressType {
    if daumApiAddressTypeNotation == "J" {
      return Jibun
    } else {
      return Road
    }
  }
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
  
  override func postUrl() -> String {
    if let userId = MyInfo.sharedMyInfo().userId {
      return "users/\(userId)/delivery-destinations"
    }
    return "users/delivery-destinations"
  }
  
  override func putUrl() -> String {
    if let userId = MyInfo.sharedMyInfo().userId, id = id {
      return "users/\(userId)/delivery-destinations/\(id)"
    }
    return "users/delivery-destinations"
  }
  
  override func postParameter() -> AnyObject? {
    return parameter()
  }
  
  override func putParameter() -> AnyObject? {
    return parameter()
  }
  
  override func assignObject(data: AnyObject?) {
    if let address = data as? [String: AnyObject] {
      id = address[kObjectPropertyKeyId] as? Int
      addressType = AddressType.addressType(with: address[kAddressPropertyKeyReceiverAddressType] as? String)
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
  
  private func parameter() -> [String: AnyObject] {
    var parameter = [String: AnyObject]()
    parameter[kAddressPropertyKeyName] = receiverName
    parameter[kAddressPropertyKeyPhone] = receiverPhone
    parameter[kAddressPropertyKeyZipCode1] = zipcode01
    parameter[kAddressPropertyKeyZipCode2] = zipcode02
    parameter[kAddressPropertyKeyReceiverZonecode] = zonecode
    parameter[kAddressPropertyKeyReceiverAddressType] = addressType?.rawValue
    parameter[kAddressPropertyKeyReceiverRoadAddress] = roadAddress
    parameter[kAddressPropertyKeyReceiverJibunAddress] = jibunAddress
    parameter[kAddressPropertyKeyDetailAddress] = detailAddress
    print(parameter)
    return parameter
  }
  
  func assign(address: [String: String]) {
    addressType = AddressType.addressType(with: address[kAddressPropertyKeyUserSelectedType])
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
        return address + " " + detailAddress
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
