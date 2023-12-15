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
                        .fill(weekStore.selectedDate == nil ? .clear : (week.dates[i] == week.referenceDate ? Color(red: 0.439, green: 0.298, blue: 1.0) : .clear))
                        .frame(height: 69)
//                        .overlay(RoundedRectangle(cornerRadius: 15)
//                            .stroke(week.dates[i].isSameDay(as: Date()) ? Color(red: 0.439, green: 0.298, blue: 1.0).opacity(0.7) : .gray.opacity(0.7))
//                            .frame(height: 60)
//                        )
        
                    VStack(spacing: 7) {
                        VStack(spacing: 0) {
                            Text(week.dates[i].toString(format: "EEE"))
                                .font(.custom("Nunito", size: 14))
                                .foregroundColor(determineTextColorDay(for: week.dates[i], with: week.referenceDate))
                                .frame(maxWidth: .infinity)
                            
                            Text(week.dates[i].toString(format: "d"))
                                .font(.custom("Nunito-Bold", size: 14))
                                .frame(maxWidth: .infinity)
                                .foregroundColor(determineTextColorDate(for: week.dates[i], with: week.referenceDate))
                        }
                        Circle()
                            .fill(taskViewModel.hasTasksDueAndNotDone(date: week.dates[i]) ? Color.yellow : Color.clear)
                            .frame(width: 7, height: 7)
                        
                    }
                }.onTapGesture {
                    withAnimation {
                        if weekStore.selectedDate == nil || weekStore.selectedDate != week.dates[i] {
                            weekStore.selectedDate = week.dates[i]
                            weekStore.pseudoSelectedDate = weekStore.startOfWeek(for: week.dates[i])
                        } else {
                            weekStore.pseudoSelectedDate = weekStore.startOfWeek(for: weekStore.selectedDate!)
                            weekStore.selectedDate = nil
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }
    func determineTextColorDate(for date: Date, with referenceDate: Date) -> Color {
        if date == referenceDate && weekStore.selectedDate != nil {
            return .white
        }
        if date.isSameDay(as: Date()) {
            return Color(red: 0.439, green: 0.298, blue: 1.0)
        } else {
            return .black
        }
    }
    
    func determineTextColorDay(for date: Date, with referenceDate: Date) -> Color {
        if date == referenceDate && weekStore.selectedDate != nil {
            return .white
        }
        if date.isSameDay(as: Date()) {
            return Color(red: 0.439, green: 0.298, blue: 1.0)
        } else {
            return .gray
        }
    }
}



