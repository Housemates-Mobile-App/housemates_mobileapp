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
        let completed = taskViewModel.getCompletedTasksForGroup(user.group_id)
        VStack(spacing: 0) {
         
            Text("Dashboard")
              .font(.custom("Nunito-Bold", size: 26))
              .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
              .padding()
      
        
          
          CustomTabBar(selectedTab: $selectedTab, tabs: [(icon: "person.3.fill", title: "Statistics"), (icon: "person.fill", title: "Calendar")])
          
          if selectedTab == 0 {
            
            
            
            HStack {
              Text("Your Pending Tasks")
                .font(.custom("Lato-Bold", size: 15))
              Spacer()
            }.padding()
            
            
            HStack {
              Text("Statistics")
                .font(.custom("Lato-Bold", size: 15))
              Spacer()
            }.padding()
            
            Spacer()
          }
          
          if selectedTab == 1 {
            ScrollView {
              
              
              calendar(completed: completed, user: user)
            }
            Spacer()
          }
         
          
         
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
  func cardView(value: DateValue, completed: [task]) -> some View {
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
    let lightPurple = Color(red: 0.439 * 3, green: 0.298 * 3, blue: 1.0 * 3)
   
    VStack {
      if value.day != -1 {
        
          
          if let task = completed.first(where: { task in
            return isSameDay(task: task, currDate: value.date)
          }){
            
            VStack {
              
              Spacer()
              Text("\(value.day)")
                .font(.custom("Lato", size: 14))
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
                    .stroke(SameDaySelect(calDate: value.date, currDate: currDay) ? lightPurple : .clear, lineWidth: 3)
              )
              
              
            
          }
          else {
            VStack {
              
              
              Spacer()
              Text("\(value.day)")
                .font(.custom("Lato", size: 14))
                
                .frame(maxWidth: .infinity)
              Spacer()
            }.frame(width: 35, height: 35, alignment: .top)
            
              .background(
                RoundedRectangle(cornerRadius: 5)
                  .fill(.gray.opacity(0.1))
                )
              .overlay(
                  RoundedRectangle(cornerRadius: 5)
                    .stroke(SameDaySelect(calDate: value.date, currDate: currDay) ? lightPurple : .clear, lineWidth: 3)
              )
//
              
          }
        
        
      }
    }
    
    
    
    
        
    
  }
  
  private func userProfileImage(for user: User) -> some View {
      AsyncImage(url: URL(string: user.imageURLString ?? "")) { image in
          image.resizable()
      } placeholder: {
          Image(systemName: "person.circle").resizable()
      }
      .aspectRatio(contentMode: .fill)
      .frame(width: 35, height: 35)
      .clipShape(Circle())
      .overlay(Circle().stroke(Color.white, lineWidth: 2))
      .padding(5)
  }
  
  private func taskCard(task: task, user: User) -> some View {
//    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
    VStack {
      
      
      
      if let uid = task.user_id {
        if let user = userViewModel.getUserByID(uid) {
          ZStack {
            Image(task.icon ?? "moon")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 65, height: 65)
              
              
//              .overlay(Circle().stroke(Color.purple, lineWidth: 2))
              .padding(7.5)
           
              .background(Color(red: 0.439, green: 0.298, blue: 1.0))
              .clipShape(Circle())
              
            
            userProfileImage(for: user)
              .offset(x: 35, y: 35)
          }
          Text(task.name)
            .font(.custom("Lato-Bold", size: 15))
          Text("Completed by \(user.first_name) \(user.last_name)")
            .font(.custom("Lato", size: 12))
            .foregroundColor(Color.gray)
            
        }
        
        
      }
      
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 16)
        .stroke(Color(red: 0.439, green: 0.298, blue: 1.0), lineWidth: 3))
        
  }
  private func calendar(completed: [task], user: User) -> some View {
    
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
          
        }.padding()
        
        HStack {
          ForEach(days, id: \.self) { day in
            
            Text(day)
              .padding(.horizontal, 5)
              .font(.custom("Lato-Bold", size: 12))
              .frame(maxWidth: .infinity)
            
          }
        }
        
        let cols = Array(repeating: GridItem(.flexible()), count: 7)
        
        LazyVGrid(columns: cols, spacing: 10) {
          ForEach(extract()) { value in
            cardView(value: value, completed: completed)
              .padding(.vertical, 2)
            
            //            .background (
            //              RoundedRectangle(cornerSize: 15, style: .continuous)
            //              .fill(.purple)
            //            )
              .onTapGesture {
                currDay = value.date
              }
          }
          
        }
      }.frame(height: 400, alignment: .top)
      
      
      Text("Completed Tasks")
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.custom("Lato-Bold", size: 15))
        .padding()
      if completed.contains(where: { task in
          isSameDay(task: task, currDate: currDay)
      }) {
          
        ScrollView(.horizontal, showsIndicators: false) {
          
          HStack {
            
            
            ForEach(completed.filter({ task in
              isSameDay(task: task, currDate: currDay)
            }), id: \.id) { task in
              taskCard(task: task, user: user)
                .padding(.horizontal)
              
            }
          }
        }
      } else {
          Text("Nothing here, complete a task!!")
          .frame(maxWidth: .infinity, alignment: .leading)
          .font(.custom("Lato", size: 15))
          .padding(.horizontal)
      }

      
      
    }
    .padding()
    
    .onChange(of: currMonth) { newVal in
      currDay = getCurrMonth()
      
    }
    
    

  }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    let tabs: [(icon: String, title: String)]
    @Namespace private var namespace
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
    var body: some View {
        HStack {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.easeInOut) {
                        self.selectedTab = index
                    }
                }) {
                    VStack {
                      HStack {
                        Image(systemName: tabs[index].icon)
                        Text(tabs[index].title)
                          .font(.custom("Nunito-Bold", size: 15))
                      }
                     
                        if selectedTab == index {
                            deepPurple.frame(height: 2)
                                .matchedGeometryEffect(id: "tabIndicator", in: namespace)
                        } else {
                            Color.clear.frame(height: 2)
                        }
                    }
                }
                .foregroundColor(self.selectedTab == index ? deepPurple : .gray)
            }
        }
        .padding([.horizontal])
        .background(Color.white)
        
    }
}
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

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
