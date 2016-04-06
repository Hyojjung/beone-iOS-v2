
import Foundation
import CoreData

extension MyInfo {
  @NSManaged var accessToken: String?
  @NSManaged var authenticationId: NSNumber?
  @NSManaged var deviceToken: String?
  @NSManaged var refreshToken: String?
  @NSManaged var email: String?
  @NSManaged var name: String?
  @NSManaged var account: String?
  @NSManaged var phone: String?
  @NSManaged var locationName: String?
  @NSManaged var gender: String?
  @NSManaged var locationId: NSNumber?
  @NSManaged var point: NSNumber?
  @NSManaged var userDeviceInfoId: NSNumber?
  @NSManaged var userId: NSNumber?
  @NSManaged var birthday: NSDate?
}
