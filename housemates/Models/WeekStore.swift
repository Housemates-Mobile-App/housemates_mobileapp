//
//  WeekStore.swift
//
//  source: https://github.com/philippkno/InfiniteWeekView
//

import Foundation

enum TimeDirection {
    case future
    case past
    case unknown
}

class WeekStore: ObservableObject {
    @Published var weeks: [Week] = []
    @Published var selectedDate: Date? {
        didSet {
            updateWeeks()
        }
    }
    
    var pseudoSelectedDate: Date

    init(with date: Date = Date()) {
//        self.selectedDate = Calendar.current.startOfDay(for: date)
//        calcWeeks(with: selectedDate)
        pseudoSelectedDate = Calendar.current.startOfDay(for: Date())
        updateWeeks()
    }
    
    func startOfWeek(for date: Date) -> Date {
        guard let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) else {
            return date
        }
        return startOfWeek
    }
    
    private func updateWeeks() {
        // use selectedDate if available, elsee fall back to pseudoSelectedDate
        pseudoSelectedDate = startOfWeek(for:pseudoSelectedDate)
        let date = selectedDate ?? pseudoSelectedDate
        calcWeeks(with: date)
    }

    private func calcWeeks(with date: Date) {
        weeks = [
            week(for: Calendar.current.date(byAdding: .day, value: -7, to: date)!, with: -1),
            week(for: date, with: 0),
            week(for: Calendar.current.date(byAdding: .day, value: 7, to: date)!, with: 1)
        ]
    }

    private func week(for date: Date, with index: Int) -> Week {
        var result: [Date] = .init()

        guard let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) else { return .init(index: index, dates: [], referenceDate: date) }

        (0...6).forEach { day in
            if let weekday = Calendar.current.date(byAdding: .day, value: day, to: startOfWeek) {
                result.append(weekday)
            }
        }

        return .init(index: index, dates: result, referenceDate: date)
    }

    func selectToday() {
        select(date: Date())
    }

    func select(date: Date) {
        selectedDate = Calendar.current.startOfDay(for: date)
    }

    func update(to direction: TimeDirection) {
        switch direction {
        case .future:
            if selectedDate != nil {
                selectedDate = Calendar.current.date(byAdding: .day, value: 7, to: selectedDate!)!
                pseudoSelectedDate = startOfWeek(for:selectedDate!)
            } else {
                pseudoSelectedDate = Calendar.current.date(byAdding: .day, value: 7, to: pseudoSelectedDate)!
            }
        case .past:
            if selectedDate != nil {
                selectedDate = Calendar.current.date(byAdding: .day, value: -7, to: selectedDate!)!
                pseudoSelectedDate = startOfWeek(for:selectedDate!)
            } else {
                pseudoSelectedDate = Calendar.current.date(byAdding: .day, value: -7, to: pseudoSelectedDate)!
            }
        case .unknown:
            selectedDate = selectedDate
            pseudoSelectedDate = startOfWeek(for:selectedDate!)
        }
        updateWeeks()
    }
}
