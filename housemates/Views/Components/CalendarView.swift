//
//  CalendarView.swift
//  housemates
//
//  Created by Sean Pham on 12/13/23.
//

import SwiftUI
import CachedAsyncImage

struct CalendarView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var tabBarViewModel : TabBarViewModel
    
    @State private var currMonth: Int = 0
    @State private var currDay: Date = Date()
    let user: User
    let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        if let user = authViewModel.currentUser {
            ScrollView {
                calendar(user: user)
            }.onAppear {
                tabBarViewModel.hideTabBar = false
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


    private func sameDaySelect(calDate: Date, currDate: Date) -> Bool {
        return Calendar.current.isDate(calDate, inSameDayAs: currDate)
    }

    private func getMonthYear() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM YYYY"
        let date = formatter.string(from: currDay)
        return date.components(separatedBy: " ")
    }

    @ViewBuilder
    func cardView(value: DateValue, user: User) -> some View {
        let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
        let darkPurple = Color(red: 0.439 * 0.5, green: 0.298 * 0.5, blue: 1.0 * 0.5)
        
        VStack {
            if value.day != -1 {
                
                SmallSquareCalendar(date: value.date, user: user)
            }
        }
        
    }

    private func calendar(user: User) -> some View {
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
                }
                .padding(.vertical)
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
                        cardView(value: value, user: user)
                            .padding(.vertical, 2)
                    }
                }
            }
            .frame(height: 400, alignment: .top)
        }.padding()
            .padding(.bottom, 40)
            .onChange(of: currMonth) { newVal in
              currDay = getCurrMonth()
        }
    }
}

struct SmallSquareCalendar: View {
    @EnvironmentObject var postViewModel: PostViewModel
    @State private var isPopoverPresented = false

    let date: Date
    let user: User
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
    var body: some View {
        let day = Calendar.current.component(.day, from: date)
        let isToday = Calendar.current.isDateInToday(date)
        let post = postViewModel.getUserPostForDay(user: user, date: date)
        

        RoundedRectangle(cornerRadius: 6)
            .foregroundColor(.clear)
//            .stroke(Color.gray.opacity(0.5), lineWidth: 2)
            .frame(width: UIScreen.main.bounds.width * 0.1, height:  UIScreen.main.bounds.height * 0.0675)
            .padding(2) // Optional: Add padding between squares
            .overlay(
            
                ZStack {
                    if let afterImageURL = post?.afterImageURL,
                       let afterPostURL = URL(string: afterImageURL) {
                        
                            
                        CachedAsyncImage(url: afterPostURL) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width * 0.1, height:  UIScreen.main.bounds.height * 0.0675)
                                .cornerRadius(6)
                            //                                .overlay(Color.black.opacity(0.35).clipShape(RoundedRectangle(cornerRadius: 25))) // Adjust opacity as needed
                        } placeholder: {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                .frame(width: UIScreen.main.bounds.width * 0.1, height:  UIScreen.main.bounds.height * 0.0675)
                                .cornerRadius(6)
                        }
                        
                    }
                   if isToday {
                       Circle()
                           .foregroundColor(deepPurple)
                           .frame(width: UIScreen.main.bounds.width * 0.083)
                   }
                    Text("\(day)")
                        .foregroundColor((isToday || post != nil) ? Color.white : deepPurple)
                        .font(.custom("Lato-Bold", size: 17.5))
               }
               
            )
            .onTapGesture {
                isPopoverPresented = true
            }
            .popover(isPresented: $isPopoverPresented) {
                // Add your fullscreen content here
                if let shownPost = post {
                    CalendarPostView(isPresented: $isPopoverPresented, post: shownPost, user: user)
                        .presentationCompactAdaptation(.fullScreenCover)
                }
            }
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

//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView()
//    }
//}

