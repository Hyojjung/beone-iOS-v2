
import UIKit
//
//enum DateComponentType: Int {
//  case DateComponentTypeYear = 0
//  case DateComponentTypeMonth
//  case DateComponentTypeDay
//  case DateComponentTypeHour
//}
//
let kKoreanTimeZone = 9 * 60 * 60
//let kHalfHour = 30.0
let kNoonTime = 12

extension String {
  func date() -> NSDate? {
    return DateFormatterHelper.serverDateFormatter().dateFromString(self)
  }
  
  func day() -> NSDate? {
    let serverDayFormatter = NSDateFormatter()
    serverDayFormatter.dateFormat = "yyyy-MM-dd"
    return serverDayFormatter.dateFromString(self)
  }
}

extension NSDate {
  
  func rangeReservationDateString() -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.timeZone = NSTimeZone(abbreviation: "JST")
    dateFormatter.dateFormat = "yyyy년 M월 d일 E요일";
    return dateFormatter.stringFromDate(self)
  }
  
  func briefDateString() -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.timeZone = NSTimeZone(abbreviation: "JST")
    dateFormatter.dateFormat = "yyyy.MM.dd";
    return dateFormatter.stringFromDate(self)
  }
  
  func serverDateString() -> String {
    return DateFormatterHelper.serverDateFormatter().stringFromDate(self)
  }
  
  func dueDateDateString() -> String {
    return paidAtDateString() + "까지"
  }
  
  func paidAtDateString() -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.timeZone = NSTimeZone(abbreviation: "JST")
    dateFormatter.dateFormat = "yyyy년 MMM d일 HH시 mm분"
    return dateFormatter.stringFromDate(self)
  }
  
  func dateComponent() -> (month: Int, day: Int) {
    if let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) {
      calendar.timeZone = NSTimeZone(forSecondsFromGMT: kKoreanTimeZone)
      let components = calendar.components([.Month, .Day], fromDate: self)
      return (components.month, components.day)
    }
    fatalError("no date component")
  }
  
  func hour() -> Int {
    if let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) {
      calendar.timeZone = NSTimeZone(forSecondsFromGMT: kKoreanTimeZone)
      let components = calendar.components([.Hour], fromDate: self)
      return components.hour
    }
    fatalError("no date component")
  }
  
  func year() -> Int {
    if let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) {
      calendar.timeZone = NSTimeZone(forSecondsFromGMT: kKoreanTimeZone)
      let components = calendar.components([.Year], fromDate: self)
      return components.year
    }
    fatalError("no date component")
  }
  
  func hourIntervalFromDate(date: NSDate) -> Int {
    let calendar: NSCalendar = NSCalendar.currentCalendar()
    let components = calendar.components([.Hour], fromDate: date, toDate: self, options: [])
    return components.hour
  }
  
  func orderItemSetProgressedAt() -> String? {
    if let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) {
      let dateComponents = calendar.components([.Day, .Hour], fromDate: self, toDate: NSDate(), options: [])
      if let dayPassed = self.dayPassed(from: NSDate()) {
        if dayPassed == 0 {
          return "\(dateComponents.hour)시간 전"
        } else if dayPassed == 1 {
          return "하루 전"
        } else if dayPassed == 2 {
          return "이틀 전"
        } else {
          return "\(dayPassed)일 전"
        }
      }
    }
    return nil
  }
  
  func dayPassed(from date: NSDate) -> Int? {
    if let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) {
      let dateComponents = calendar.components([.Day, .Hour], fromDate: self, toDate: date, options: [])
      let earlyDate = calendar.dateByAddingUnit([.Hour],
        value: dateComponents.hour,
        toDate: self,
        options: [])
      if earlyDate?.briefDateString() != self.briefDateString() {
        return dateComponents.day + 1
      } else {
        return dateComponents.day
      }
    }
    return nil
  }
}

class DateFormatterHelper: NSObject {
  static func serverDateFormatter() -> NSDateFormatter {
    let serverDateFormatter = NSDateFormatter()
    serverDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return serverDateFormatter
  }
}
