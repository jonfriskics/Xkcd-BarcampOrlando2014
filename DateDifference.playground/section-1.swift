import Foundation

let now:NSDate = NSDate().dateByAddingTimeInterval(0)

let swiftRelease:NSDate = {
    let releaseDate = NSDateComponents()
    releaseDate.month = 9
    releaseDate.day = 17
    releaseDate.year = 2014
    releaseDate.hour = 13
    
    return NSCalendar(
        calendarIdentifier: NSGregorianCalendar).dateFromComponents(releaseDate)!
    }()

let daysFromRelease:NSDateComponents = {
    return NSCalendar(
        calendarIdentifier: NSGregorianCalendar).components(
            NSCalendarUnit.DayCalendarUnit, fromDate: swiftRelease,
            toDate: now, options: nil)
    }()

println(daysFromRelease.day)