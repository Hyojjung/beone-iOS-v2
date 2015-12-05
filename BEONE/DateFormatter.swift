
import UIKit
//
//enum DateComponentType: Int {
//  case DateComponentTypeYear = 0
//  case DateComponentTypeMonth
//  case DateComponentTypeDay
//  case DateComponentTypeHour
//}
//
//let kClockTime = 60.0
//let kHalfHour = 30.0

extension String {
  func date() -> NSDate? {
    return DateFormatterHelper.serverDateFormatter().dateFromString(self)
  }
}

extension NSDate {
//  func preferredDeliveryDateString() -> String {
//    let dateFormatter = NSDateFormatter()
//    dateFormatter.timeZone = NSTimeZone(abbreviation: "JST")
//    if dayIntervalFromNow() == 0 {
//      dateFormatter.dateFormat = "오늘 a h:mm";
//      return dateFormatter.stringFromDate(self)
//    } else if dayIntervalFromNow() == 1 {
//      dateFormatter.dateFormat = "내일 a h:mm";
//      return dateFormatter.stringFromDate(self)
//    } else {
//      dateFormatter.dateFormat = "M월 d일 (E) a h:mm";
//      return dateFormatter.stringFromDate(self)
//    }
//  }
//  
  func rangeReservationDateString() -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.timeZone = NSTimeZone(abbreviation: "JST")
    dateFormatter.dateFormat = "yyyy년 M월 d일 E요일";
    return dateFormatter.stringFromDate(self)
  }
//
//  func pushDateString() -> String {
//    let dateFormatter = NSDateFormatter()
//    dateFormatter.timeZone = NSTimeZone(abbreviation: "JST")
//    dateFormatter.dateFormat = "yyyy.MM.dd a h:mm";
//    return dateFormatter.stringFromDate(self)
//  }
//  
//  func dateString() -> String {
//    return DateFormatterHelper.serverDateFormatter().stringFromDate(self)
//  }
//  
  func dateComponent() -> (Int, Int)? {
    if let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) {
    calendar.timeZone = NSTimeZone(forSecondsFromGMT: 9 * 60 * 60)
    let components = calendar.components([.Month, .Day], fromDate: self)
    return (components.month, components.day)
    }
    return nil
  }
//
//  func day() -> NSDate {
//    let (year, month, day, _, _) = self.dateComponent()
//    let component = NSDateComponents()
//    component.year = year
//    component.month = month
//    component.day = day
//    return NSCalendar.currentCalendar().dateFromComponents(component)!
//  }
//  
//  func dayIntervalFromNow() -> Int {
//    let calendar: NSCalendar = NSCalendar.currentCalendar()
//    let date = NSDate().day()
//    let components = calendar.components([.Day], fromDate: date, toDate: self, options: [])
//    return components.day
//  }
//  
//  func rangeReservationStartDate(startHour: Int) -> NSDate {
//    let timeInterval = NSTimeInterval(Double(startHour - 9) * kClockTime * kClockTime)
//    return self.dateByAddingTimeInterval(timeInterval)
//  }
}

class DateFormatterHelper: NSObject {
  static func serverDateFormatter() -> NSDateFormatter{
    let serverDateFormatter = NSDateFormatter()
    serverDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return serverDateFormatter
  }
}
