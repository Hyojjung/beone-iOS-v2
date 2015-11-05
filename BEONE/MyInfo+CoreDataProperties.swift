
import Foundation
import CoreData

extension MyInfo {
    @NSManaged var accessToken: String?
    @NSManaged var authenticationId: NSNumber?
    @NSManaged var deviceToken: String?
    @NSManaged var refreshToken: String?
    @NSManaged var userDeviceInfoId: NSNumber?
    @NSManaged var userId: NSNumber?

}
