
import UIKit

let kKoreanTimeZone = 9 * 60 * 60
let kSecondToDay: Double = 60 * 60 * 24
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
    dateFormatter.timeZone = DateFormatterHelper.koreanTimeZone
    dateFormatter.dateFormat = "yyyy년 M월 d일 E요일";
    return dateFormatter.stringFromDate(self)
  }
  
  func briefDateString() -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.timeZone = DateFormatterHelper.koreanTimeZone
    dateFormatter.dateFormat = "yyyy.MM.dd";
    return dateFormatter.stringFromDate(self)
  }
  
  func paidAtDateString() -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.timeZone = DateFormatterHelper.koreanTimeZone
    dateFormatter.dateFormat = "yyyy년 MMM d일 HH시 mm분"
    return dateFormatter.stringFromDate(self)
  }
  
  func serverDateString() -> String {
    return DateFormatterHelper.serverDateFormatter().stringFromDate(self)
  }
  
  func dueDateDateString() -> String {
    return paidAtDateString() + "까지"
  }
  
  func dateComponent() -> (month: Int, day: Int) {
    let calendar = DateFormatterHelper.koreanCalendar
    let components = calendar.components([.Month, .Day], fromDate: self)
    return (components.month, components.day)
  }
  
  func hour() -> Int {
    let calendar = DateFormatterHelper.koreanCalendar
    let components = calendar.components([.Hour], fromDate: self)
    return components.hour
  }
  
  func year() -> Int {
    let calendar = DateFormatterHelper.koreanCalendar
    let components = calendar.components([.Year], fromDate: self)
    return components.year
  }
  
  func hourIntervalFromDate(date: NSDate) -> Int {
    let calendar: NSCalendar = NSCalendar.currentCalendar()
    let components = calendar.components([.Hour], fromDate: date, toDate: self, options: [])
    return components.hour
  }
  
  func orderItemSetProgressedAt() -> String? {
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    let dateComponents = calendar.components([.Day, .Hour, .Minute], fromDate: self, toDate: NSDate(), options: [])
    let dayPassed = self.numberOfLeftDay(to: NSDate())
    if dayPassed == 0 {
      if dateComponents.hour < 1 {
        if dateComponents.minute < 1 {
          return "방금 전"
        }
        return "\(dateComponents.minute)분 전"
      } else {
        return "\(dateComponents.hour)시간 전"
      }
    } else if dayPassed == 1 {
      return "어제"
    } else if dayPassed == 2 {
      return "이틀 전"
    } else {
      return "\(dayPassed)일 전"
    }
  }
  
  func numberOfLeftDay(to date: NSDate) -> Int {
    let calendar = DateFormatterHelper.koreanCalendar
    
    var fromDate: NSDate?, toDate: NSDate?
    
    calendar.rangeOfUnit(.Day, startDate: &fromDate, interval: nil, forDate: self)
    calendar.rangeOfUnit(.Day, startDate: &toDate, interval: nil, forDate: date)
    
    let difference = calendar.components(.Day, fromDate: fromDate!, toDate: toDate!, options: [])
    return difference.day
  }
}

class DateFormatterHelper: NSObject {
  
  static func serverDateFormatter() -> NSDateFormatter {
    let serverDateFormatter = NSDateFormatter()
    serverDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return serverDateFormatter
  }
  
  static var koreanCalendar: NSCalendar = {
    if let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) {
      calendar.timeZone = koreanTimeZone
      return calendar
    }
    fatalError("must return calendar")
  }()
  
  static var koreanTimeZone: NSTimeZone = {
    return NSTimeZone(forSecondsFromGMT: kKoreanTimeZone)
  }()
}
