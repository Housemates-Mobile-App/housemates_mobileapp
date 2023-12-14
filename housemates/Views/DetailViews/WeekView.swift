//
//  WeekView.swift
//
//  source: https://github.com/philippkno/InfiniteWeekView
//

import SwiftUI

struct WeekView: View {
    @EnvironmentObject var weekStore: WeekStore
    @EnvironmentObject var taskViewModel: TaskViewModel

    var week: Week

    var body: some View {
        HStack {
            ForEach(0..<7) { i in
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(week.dates[i] == week.referenceDate ? (week.referenceDate.isSameDay(as: Date()) ? Color(red: 0.439, green: 0.298, blue: 1.0) : Color(red: 0.725, green: 0.631, blue: 1.0)) : .clear)
                        .frame(height: 69)
//                        .overlay(RoundedRectangle(cornerRadius: 15)
//                            .stroke(week.dates[i].isSameDay(as: Date()) ? Color(red: 0.439, green: 0.298, blue: 1.0).opacity(0.7) : .gray.opacity(0.7))
//                            .frame(height: 60)
//                        )
        
                    VStack(spacing: 7) {
                        VStack(spacing: 0) {
                            Text(week.dates[i].toString(format: "EEE"))
                                .font(.custom("Nunito", size: 14))
                                .foregroundColor(week.dates[i] == week.referenceDate ? .white : .gray)
                                .frame(maxWidth: .infinity)
                            
                            Text(week.dates[i].toString(format: "d"))
                                .font(.custom("Nunito-Bold", size: 14))
                                .frame(maxWidth: .infinity)
                                .foregroundColor(week.dates[i] == week.referenceDate ? .white : (week.dates[i].isSameDay(as: Date()) ? .accentColor : .black))
                        }
                        Circle()
                            .fill(taskViewModel.hasTasksDueAndNotDone(date: week.dates[i]) ? Color.yellow : Color.clear)
                            .frame(width: 7, height: 7)
                        
                    }
                }.onTapGesture {
                    withAnimation {
                        weekStore.selectedDate = week.dates[i]
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }
}

extension Date {
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

    private func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
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
}
