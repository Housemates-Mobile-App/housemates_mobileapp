//
//  DashboardView.swift
//  housemates
//
//  Created by Bernard Sheng on 12/2/23.
//

import SwiftUI

struct DashboardView: View {
  @EnvironmentObject var taskViewModel: TaskViewModel
  @EnvironmentObject var authViewModel: AuthViewModel
  @State var currMonth: Int = 0
  let days: [String] = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"]
    var body: some View {
      if let user = authViewModel.currentUser {
        VStack() {
          HStack {
            Text("Dashboard")
              .font(.custom("Nunito-Bold", size: 26))
              .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
            Spacer()
          }.padding()
          
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
          
          calendar()
          
          Spacer()
        }
        
        
        
        
        
      }
      
        
    }
  
  private func extract() -> [DateValue] {
    let calendar = Calendar.current
    guard let currMonth = calendar.date(byAdding: .month, value: self.currMonth, to: Date()) else {
      return []
    }
    
    return currMonth.getAll().compactMap { date -> DateValue in
      let day = calendar.component(.day, from: date)
      return DateValue(day: day, date: date)
    }
  }
  
  private func calendar() -> some View {
    
//    calendar title
    VStack {
      HStack {
        VStack {
          Text("Year")
          Text("Month")
        }
        
        Spacer()
        Button(action: {}) {
          Text("Button")
        }
        
      }
      
      HStack(spacing: 0) {
        ForEach(days, id: \.self) { day in
          Text(day)
            .padding(.horizontal)
            .font(.custom("Lato", size: 15))
          
        }
      }
      
      let cols = Array(repeating: GridItem(.flexible()), count: 7)
      LazyVGrid(columns: cols, spacing: 15) {
        ForEach(extract()) { value in
          Text("\(value.day)")
            .font(.custom("Lato", size: 12))
          
        }
      }
    }
    
    
//    Days of calendar
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
    let range = calendar.range(of: .day, in: .month, for: self)!
    return range.compactMap { day -> Date in
      return calendar.date(byAdding: .day, value: day, to: self)!
    }
  }
}
