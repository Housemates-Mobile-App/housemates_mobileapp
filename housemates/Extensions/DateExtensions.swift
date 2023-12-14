//
//  DateExtensions.swift
//  housemates
//
//  Created by Daniel Gunawan on 12/14/23.
//

import Foundation

extension Date {
    var monthYearString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func isSameDay(as date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: date)
    }
    
    func monthToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: self)
    }

    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = format

        return formatter.string(from: self)
    }

    var yesterday: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }

    var tomorrow: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        var customCalendar = Calendar(identifier: .gregorian)
        customCalendar.firstWeekday = 2

        return customCalendar.isDate(self, equalTo: date, toGranularity: component)
    }

    func isInSameWeek(as date: Date) -> Bool {
        isEqual(to: date, toGranularity: .weekOfYear)
    }

    func isInSameDay(as date: Date) -> Bool {
        isEqual(to: date, toGranularity: .day)
    }
    
    func getAll() -> [Date] {
      let calendar = Calendar.current
      let start = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
      let range = calendar.range(of: .day, in: .month, for: self)!
    
      return range.compactMap { day -> Date in
        return calendar.date(byAdding: .day, value: day - 1, to: start)!
      }
    }
    
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }

}
