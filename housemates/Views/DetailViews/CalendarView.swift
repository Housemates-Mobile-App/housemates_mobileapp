import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var weekStore: WeekStore
    
//    let distantPastDate = Calendar.current.date(byAdding: .year, value: -10, to: Date()) ?? Date()
    
    var body: some View {
        VStack(spacing: 15) {
            HeaderView(selectedDate: $weekStore.selectedDate).padding(.leading)
            WeeksTabView { week in
                WeekView(week: week)
            }.frame(height: 70, alignment: .top)
            
        }
    }
    
    struct HeaderView: View {
        @EnvironmentObject var weekStore: WeekStore
        @Binding var selectedDate: Date

        var body: some View {
            let monthYearComponents = selectedDate.monthYearString.components(separatedBy: " ")
            HStack (spacing: 5){
                Text(monthYearComponents.first?.prefix(3) ?? "")
                    .font(.custom("Nunito-Bold", size: 20))
                    .foregroundColor(Color.black)
                    Text(monthYearComponents.last ?? "") // Year
                        .font(.custom("Nunito-Bold", size: 20))
                        .foregroundColor(Color.black)
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                        .font(.system(size: 20))
                        .overlay{
                            DatePicker(
                                "",
                                selection: $weekStore.selectedDate,
                                displayedComponents: [.date]
                            )
                            .blendMode(.destinationOver)
                        }
                
//                  .overlay{
//                     DatePicker(
//                         "",
//                         selection: $weekStore.selectedDate,
//                         displayedComponents: [.date]
//                     )
//                      .blendMode(.destinationOver)
//                  }
                Spacer()
            }
        }
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
