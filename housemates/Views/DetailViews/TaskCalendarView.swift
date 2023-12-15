import SwiftUI

struct TaskCalendarView: View {
    @EnvironmentObject var weekStore: WeekStore
    
//    let distantPastDate = Calendar.current.date(byAdding: .year, value: -10, to: Date()) ?? Date()
    
    var body: some View {
        VStack(spacing: 15) {
            HeaderView(dateBinding: dateBinding).padding(.leading)
            WeeksTabView { week in
                WeekView(week: week)
            }.frame(height: 70, alignment: .top)
            
        }
    }
    
    private var dateBinding: Binding<Date> {
        Binding<Date>(
            get: { weekStore.selectedDate ?? weekStore.pseudoSelectedDate },
            set: { weekStore.selectedDate = $0 }
        )
    }
    
    struct HeaderView: View {
        @EnvironmentObject var weekStore: WeekStore
        var dateBinding: Binding<Date>

        var body: some View {
            let monthYearComponents = dateBinding.wrappedValue.monthYearString.components(separatedBy: " ")
            HStack (spacing: 5){
                Text(monthYearComponents.first?.prefix(3) ?? "")
                    .font(.custom("Nunito-Bold", size: 14))
                    .foregroundColor(.primary)
                    Text(monthYearComponents.last ?? "") // Year
                        .font(.custom("Nunito-Bold", size: 14))
                        .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                        .font(.system(size: 12))
                        .overlay{
                            DatePicker(
                                "",
                                selection: dateBinding,
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

//struct TaskCalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskCalendarView()
//    }
//}
