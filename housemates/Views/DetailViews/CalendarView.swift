import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date?
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E d"
        return formatter
    }()
    
    let distantPastDate = Calendar.current.date(byAdding: .year, value: -10, to: Date()) ?? Date()
    
    var body: some View {
        VStack {
            let monthYearComponents = selectedDate?.monthYearString.components(separatedBy: " ") ?? []
            
            HStack {
                Text(monthYearComponents.first ?? "") // month component
                    .font(.custom("Nunito-Bold", size: 30))
                    .foregroundColor(Color.black)
                Text(monthYearComponents.last ?? "") // year
                    .font(.custom("Nunito-Bold", size: 30))
                    .foregroundColor(Color.purple)
                Spacer()
            }
            
            HStack(spacing: 15) {
                ForEach(0..<7) { index in
                    let date = startOfWeek(for: selectedDate ?? Date())
                        .addingTimeInterval(TimeInterval(86400 * index))
                    let dateComponents = dateFormatter.string(from: date).components(separatedBy: " ")
                    VStack (spacing: 0) {
                        Text(dateComponents.first ?? "")
                            .font(.custom("Nunito", size: 14))
                            .foregroundColor(.gray)
                        Text(dateComponents.last ?? "")
                            .frame(width: 30, height: 30)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(date.isSameDay(as: selectedDate ?? distantPastDate) ? (date.isSameDay(as: Date()) ? .purple : .black) : .clear)
                                    .opacity(date.isSameDay(as: selectedDate ?? distantPastDate) ? 1.0 : 0)
                            )
                            .foregroundColor(date.isSameDay(as: selectedDate ?? distantPastDate) ? .white : (date.isSameDay(as: Date()) ? .purple : .black))
                            .font(.custom("Nunito-Bold", size: 14))
                            .onTapGesture {
                                if date.isSameDay(as: selectedDate ?? distantPastDate) {
                                    selectedDate = nil
                                } else {
                                    selectedDate = date
                                }
                            }
                    }
                }
            }
            
            HStack {
                Button("Prev Week") {
                    selectedDate = Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: selectedDate ?? Date()) ?? selectedDate
                }
                .padding()
                
                Button("Next Week") {
                    selectedDate = Calendar.current.date(byAdding: .weekOfMonth, value: 1, to: selectedDate ?? Date()) ?? selectedDate
                }
                .padding()
            }
        }
    }
    
    func startOfWeek(for date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) ?? Date()
    }
}

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
}

//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView()
//    }
//}
