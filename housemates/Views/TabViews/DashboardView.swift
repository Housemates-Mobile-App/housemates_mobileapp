//
//  DashboardView.swift
//  housemates
//
//  Created by Bernard Sheng on 12/2/23.
//  Foundation of the code: https://www.youtube.com/watch?v=UZI2dvLoPr8&t=802s&ab_channel=Kavsoft

import SwiftUI

struct DashboardView: View {
  @EnvironmentObject var taskViewModel: TaskViewModel
  @EnvironmentObject var authViewModel: AuthViewModel
  @EnvironmentObject var userViewModel: UserViewModel
  @State private var selectedTab = 0
  
  @State var currMonth: Int = 0
  @State var currDay: Date = Date()
  let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var body: some View {
      if let user = authViewModel.currentUser {
          NavigationStack {
              let completed = taskViewModel.getCompletedTasksForGroup(user.group_id)
              let incompleted = taskViewModel.getIncompleteTasksForGroup(user.group_id)
              VStack(spacing: 0) {
                  
<<<<<<< HEAD
                  Text("Dashboard")
                      .font(.custom("Nunito-Bold", size: 26))
                      .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                      .padding(.horizontal)
                      .padding(.top, 10)
                      .padding(.bottom, 2.5)
                  
                  
=======
>>>>>>> bba238d (Nav bar titles added for views)
                  
                  CustomTabBar(selectedTab: $selectedTab)
                  
                  if selectedTab == 0 {
                      
                    StatsView(statHeight: UIScreen.main.bounds.size.width * 0.55)
                      Spacer()
                  }
                  
                  if selectedTab == 1 {
                      ScrollView {
                          
                          
                        calendar(completed: completed, incompleted: incompleted, user: user)
                      }
                      Spacer()
                  }
              }
              .navigationTitle("Dashboard")
              .navigationBarTitleDisplayMode(.inline)
          }
      }
    }
  
  private func getCurrMonth() -> Date {
    let calendar = Calendar.current
    guard let currMonth = calendar.date(byAdding: .month, value: self.currMonth, to: Date()) else {
      return Date()
    }
    
    return currMonth
  }
  
  private func extract() -> [DateValue] {
    let calendar = Calendar.current
    let currMonth = getCurrMonth()
    
    var days = currMonth.getAll().compactMap { date -> DateValue in
      let day = calendar.component(.day, from: date)
      return DateValue(day: day, date: date)
    }
    
    let offset = calendar.component(.weekday, from: days.first?.date ?? Date())
    for _ in 0..<offset-1 {
      days.insert(DateValue(day: -1, date: Date()), at: 0)
    }
    return days
  }
  
  private func isSameDay(task: task, currDate: Date) -> Bool {
    if let date_complete = task.date_completed {
      let formatter = DateFormatter()
      formatter.dateFormat = "MM.dd.yy h:mm a"
      if let date1 = formatter.date(from: date_complete) {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: currDate)
      }
      return false
      
      
    }
    else {
      return false
    }
    
  }
  
  private func isSameDue(task: task, currDate: Date) -> Bool {
    if let date_due = task.date_due {
      
      let calendar = Calendar.current
      return calendar.isDate(date_due, inSameDayAs: currDate)
    }
    return false
     
  }
  
  private func SameDaySelect(calDate: Date, currDate: Date) -> Bool {
    let calendar = Calendar.current
      return calendar.isDate(calDate, inSameDayAs: currDate)
      
    
  }
  private func getMonthYear() -> [String] {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM YYYY"
    let date = formatter.string(from: currDay)
    return date.components(separatedBy: " ")
  }
  
  @ViewBuilder
  func cardView(value: DateValue, completed: [task], incompleted: [task]) -> some View {
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
    let darkPurple = Color(red: 0.439 * 0.5, green: 0.298 * 0.5, blue: 1.0 * 0.5)
    let lightPurple = Color(red: 185.0 / 255.0, green: 161.0 / 255.0, blue: 255.0 / 255.0, opacity: 1.0)

    

   
    VStack {
      if value.day != -1 {
        
        Button(action: {currDay = value.date}) {
          
          
          
          ZStack(alignment: .bottom) {
            
            
            if let task = completed.first(where: { task in
              return isSameDay(task: task, currDate: value.date)
            }){
              
              VStack {
                
                
                
                Spacer()
                Text("\(value.day)")
                  .font(.custom("Nunito-Bold", size: 14))
                  .foregroundColor(.white)
                  .frame(maxWidth: .infinity)
              
                
                Spacer()
              }.frame(width: 35, height: 35, alignment: .top)
              
                .background(
                  RoundedRectangle(cornerRadius: 5)
                    .fill(isSameDay(task: task, currDate: value.date) ? deepPurple : .clear)
                )
                .overlay(
                  RoundedRectangle(cornerRadius: 5)
                    .stroke(SameDaySelect(calDate: value.date, currDate: currDay) ?  darkPurple : .clear, lineWidth: 3)
                )
              
              
              
            }
            
            else {
              VStack {
                
                Spacer()
            
                Text("\(value.day)")
                  .padding(.bottom)
                  .font(.custom("Nunito-Bold", size: 14))
                  .foregroundColor(.primary.opacity(0.65))
                
                  .frame(maxWidth: .infinity)
                Spacer()
              }.frame(width: 35, height: 35, alignment: .top)
              
//                .background(
//                  RoundedRectangle(cornerRadius: 5)
//                    .fill(.gray.opacity(0.1))
//                )
                .overlay(
                  RoundedRectangle(cornerRadius: 5)
                    .stroke(SameDaySelect(calDate: value.date, currDate: currDay) ? deepPurple.opacity(0.5) : .clear, lineWidth: 3)
                )
              //
              
            }
            
            if let task = incompleted.first(where: { task in
              return isSameDue(task: task, currDate: value.date)
            }){
              VStack {
                
                Spacer()
            
                Text("\(value.day)")
                  .padding(.bottom)
                  .font(.custom("Nunito-Bold", size: 14))
                  .foregroundColor(.red)
                
                  .frame(maxWidth: .infinity)
                Spacer()
              }.frame(width: 35, height: 35, alignment: .top)
//              Circle()
//                .frame(width: 35, height: 35)
//                .foregroundColor(lightPurple)
               
              
            }
            
            //          if a due date in either unclaimed or claimed has a due date
            //            put a circle
            
            
            
          }
        }
        
        
        
      }
    }
  }
  
  private func calendar(completed: [task], incompleted: [task], user: User) -> some View {
    
//    calendar title
    VStack {
      
      VStack {
        
        
        HStack {
          VStack(alignment: .leading) {
            Text(getMonthYear()[1])
              .font(.custom("Lato", size: 12))
            Text(getMonthYear()[0])
              .font(.custom("Nunito-Bold", size: 26))
          }
          
          Spacer()
          Button(action: {
            withAnimation {
              currMonth -= 1
            }
            
            
          }) {
            
            Image(systemName: "arrow.left")
              .font(.custom("Lato-Bold", size: 15))
            
          }
          Button(action: {
            withAnimation {
              
              
              currMonth += 1
            }
            
          }) {
            Image(systemName: "arrow.right")
              .font(.custom("Lato-Bold", size: 15))
          }
          
        }.padding(.vertical)
        
        HStack {
          ForEach(days, id: \.self) { day in
            
            Text(day)
              .padding(.horizontal, 5)
              .font(.custom("Lato-Bold", size: 14))
              .frame(maxWidth: .infinity)
            
          }
        }
        
        let cols = Array(repeating: GridItem(.flexible()), count: 7)
        
        LazyVGrid(columns: cols, spacing: 10) {
          ForEach(extract()) { value in
            cardView(value: value, completed: completed, incompleted: incompleted)
              .padding(.vertical, 2)
            
            //            .background (
            //              RoundedRectangle(cornerSize: 15, style: .continuous)
            //              .fill(.purple)
            //            )
              
          }
          
        }
      }.frame(height: 400, alignment: .top)
      
      
      Text("Completed Tasks")
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.custom("Lato-Bold", size: 15))
        .padding(.vertical)
        
      if completed.contains(where: { task in
          isSameDay(task: task, currDate: currDay)
      }) {
          
        ScrollView(.horizontal, showsIndicators: false) {
          
          HStack() {
            
            
            ForEach(completed.filter({ task in
              isSameDay(task: task, currDate: currDay)
            }), id: \.id) { task in
                NavigationLink(destination: TaskDetailView(currUser: user, currTask:task)) {
                    taskCard(task: task, user: user)
                }
              
            }
          }
        }
      } else {
          Text("Nothing here, complete a task!!")
          .frame(maxWidth: .infinity, alignment: .leading)
          .font(.custom("Lato", size: 15))
          
      }

      
      
    }
    .padding()
    .padding(.bottom, 40)
    .onChange(of: currMonth) { newVal in
      currDay = getCurrMonth()
      
    }
    
    

  }
}
//reference: https://www.youtube.com/watch?v=Zv1jw__VKTo&ab_channel=Kavsoft
struct CustomTabBar : View {
    
    @Binding var selectedTab : Int
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
    var body : some View{
        
        HStack{
            
            Button(action: {
                
                self.selectedTab = 0
                
            }) {
                
              Image(systemName: "chart.bar.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.vertical,10)
                    .padding(.horizontal,25)
                    .background(self.selectedTab == 0 ? Color.white : Color.clear)
                    .clipShape(Capsule())
            }
            .foregroundColor(self.selectedTab == 0 ? deepPurple : .gray.opacity(0.5))
            
            Button(action: {
                
                self.selectedTab = 1
                
            }) {
                
              Image(systemName: "calendar")
                .resizable()
                .frame(width: 20, height: 20)
                .padding(.vertical,10)
                .padding(.horizontal,25)
                .background(self.selectedTab == 1 ? Color.white : Color.clear)
                .clipShape(Capsule())
            }
            .foregroundColor(self.selectedTab == 1 ? deepPurple : .gray.opacity(0.5))
            
            }.padding(8)
        .background(.gray.opacity(0.1))
            .clipShape(Capsule())
            
    }
}







//struct CustomTabBar: View {
//    @Binding var selectedTab: Int
//    let tabs: [(icon: String, title: String)]
//    @Namespace private var namespace
//    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
//    var body: some View {
//        HStack {
//            ForEach(0..<tabs.count, id: \.self) { index in
//                Button(action: {
//                    withAnimation(.easeInOut) {
//                        self.selectedTab = index
//                    }
//                }) {
//                    VStack {
//                      HStack {
//                        Image(systemName: tabs[index].icon)
//                        Text(tabs[index].title)
//                          .font(.custom("Nunito-Bold", size: 15))
//                      }
//
//                        if selectedTab == index {
//                            deepPurple.frame(height: 2)
//                                .matchedGeometryEffect(id: "tabIndicator", in: namespace)
//                        } else {
//                            Color.clear.frame(height: 2)
//                        }
//                    }
//                }
//                .foregroundColor(self.selectedTab == index ? deepPurple : .gray)
//            }
//        }
//        .padding([.horizontal])
//        .background(Color.white)
//
//    }
//}
//struct DashboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardView()
//    }
//}

extension Date {
  func getAll() -> [Date] {
    let calendar = Calendar.current
    let start = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    let range = calendar.range(of: .day, in: .month, for: self)!
  
    return range.compactMap { day -> Date in
      return calendar.date(byAdding: .day, value: day - 1, to: start)!
    }
  }
}
