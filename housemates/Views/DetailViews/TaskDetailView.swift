import SwiftUI
import CachedAsyncImage

struct TaskDetailView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var tabBarViewModel : TabBarViewModel

    let currUser: User
    let currTask: task
    
    var body: some View {
        let assigneeUserId = currTask.user_id ?? nil
        let assignee = assigneeUserId != nil ? userViewModel.getUserByID(assigneeUserId!) : nil
        let imageURL = URL(string: assignee?.imageURLString ?? "")
        
        ScrollView {
          
            VStack(alignment: .leading, spacing: 10) {
              SwiftUI.Group {
                
                  HStack {
                    Spacer()
                 
                        Image(currTask.icon ?? "dalle2")
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          .frame(width: 70, height: 70)
                          .foregroundColor(.gray)
                          .padding(5)
                      Spacer()
                    }
                    
    
                  Text("Task Name")
                      .font(.custom("Lato-Bold", size: 18))
                  Text(currTask.name)
                      .font(.custom("Lato-Regular", size: 14))
                      .foregroundColor(Color(red: 0.486, green: 0.486, blue: 0.486))
                  Divider()
                      .padding(.vertical, 10)
                  
                  Text("Status")
                      .font(.custom("Lato-Bold", size: 18))
                  HStack {
                      if (currTask.status != .done) {
                          if (assignee?.first_name == nil) {
                              Text("Unclaimed")
                                  .font(.custom("Lato-Regular", size: 14))
                                  .foregroundColor(Color(red: 0.486, green: 0.486, blue: 0.486))
                              
                          }
                          else {
                              Text("Claimed by \(assignee?.first_name ?? "Nobody")")
                                  .font(.custom("Lato-Regular", size: 14))
                                  .foregroundColor(Color(red: 0.486, green: 0.486, blue: 0.486))
                              
                              CachedAsyncImage(url: imageURL) { image in
                                  image
                                      .resizable()
                                      .aspectRatio(contentMode: .fill)
                                      .frame(width: 35, height: 35)
                                      .clipShape(Circle())
                                      .foregroundColor(.gray)
                              } placeholder: {
                                  // MARK: Default user profile picture
                                  Circle()
                                      .fill(
                                          LinearGradient(
                                              gradient: Gradient(colors: [Color.gray.opacity(0.8), Color.gray.opacity(0.4)]),
                                              startPoint: .topLeading,
                                              endPoint: .bottomTrailing
                                          )
                                      )
                                      .frame(width: 35, height: 35)
                                      .overlay(
                                        Text("\(assignee!.first_name.prefix(1).capitalized + assignee!.last_name.prefix(1).capitalized)")
                                            
                                              .font(.custom("Nunito-Bold", size: 16))
                                              .foregroundColor(.white)
                                      )
                              }
                          }
                          
                      }
                      else {
                          Text("Completed by \(assignee?.first_name ?? "Error)")")
                              .font(.custom("Lato-Regular", size: 14))
                              .foregroundColor(Color(red: 0.486, green: 0.486, blue: 0.486))
                          
                          CachedAsyncImage(url: imageURL) { image in
                              image
                                  .resizable()
                                  .aspectRatio(contentMode: .fill)
                                  .frame(width: 35, height: 35)
                                  .clipShape(Circle())
                                  .foregroundColor(.gray)
                          } placeholder: {
                              // MARK: Default user profile picture
                              Circle()
                                  .fill(
                                      LinearGradient(
                                          gradient: Gradient(colors: [Color.gray.opacity(0.8), Color.gray.opacity(0.4)]),
                                          startPoint: .topLeading,
                                          endPoint: .bottomTrailing
                                      )
                                  )
                                  .frame(width: 35, height: 35)
                                  .overlay(
                                    Text("\(assignee!.first_name.prefix(1).capitalized + assignee!.last_name.prefix(1).capitalized)")
                                        
                                          .font(.custom("Nunito-Bold", size: 16))
                                          .foregroundColor(.white)
                                  )
                          }
                      }
                      
                      
                      
                      
                  }
                Divider()
                  .padding(.vertical, 10)
                
              }
              
              Text("Create Date")
                  .font(.custom("Lato-Bold", size: 18))
              Text(createdDateText(for: currTask))
                  .font(.custom("Lato-Regular", size: 14))
                  .foregroundColor(Color(red: 0.486, green: 0.486, blue: 0.486))
              Divider()
                  .padding(.vertical, 10)
              
              
                if currTask.description != "" {
                    Text("Description")
                        .font(.custom("Lato-Bold", size: 18))
                    Text(currTask.description)
                        .font(.custom("Lato-Regular", size: 14))
                        .foregroundColor(Color(red: 0.486, green: 0.486, blue: 0.486))
                    Divider()
                        .padding(.vertical, 10)
                }
                
                Text("Due Date")
                    .font(.custom("Lato-Bold", size: 18))
                Text("\(dueDateText(for: currTask))")
                    .font(.custom("Lato-Regular", size: 14))
                    .foregroundColor(Color(red: 0.486, green: 0.486, blue: 0.486))
                Divider()
                    .padding(.vertical, 10)
                
                Text("How Often")
                    .font(.custom("Lato-Bold", size: 18))
                //hardcoded, this data doesnt exist yet
                Text("\(recurrenceText(for: currTask))")
                    .font(.custom("Lato-Regular", size: 14))
                    .foregroundColor(Color(red: 0.486, green: 0.486, blue: 0.486))
            }.padding()
                .padding(.vertical, 10)
            
        }
//        .padding(.top, 10)
        .navigationTitle("Task Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if (currTask.status == .unclaimed) {
                  NavigationLink(destination: AddTaskView(taskIconStringHardcoded: currTask.icon ?? "dalle2", taskNameHardcoded: currTask.name, user: currUser, editableTask: currTask)) {
                    Label("", systemImage: "pencil")
                      .font(.system(size: 25))
                      .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                  }
                }
            }
        }.onAppear {
            tabBarViewModel.hideTabBar = true
        }
    }

    
    func recurrenceText(for task: task) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy" // Format for displaying the date
        
        switch task.recurrence {
        case .none:
            return "Doesn't Repeat"

        case .daily:
            return "Daily"

        case .weekly:
            guard let startDate = task.recurrenceStartDate else { return "Weekly" }
            let weekday = Calendar.current.component(.weekday, from: startDate)
            let weekdayName = formatter.weekdaySymbols[weekday - 1] // Adjusting for index
            let endDateText = task.recurrenceEndDate != nil ? " until \(formatter.string(from: task.recurrenceEndDate!))" : ""
            return "Weekly on \(weekdayName)\(endDateText)"

        case .monthly:
            guard let startDate = task.recurrenceStartDate else { return "Monthly" }
            let day = Calendar.current.component(.day, from: startDate)
            let (ordinal, weekdayName) = ordinalWeekday(for: startDate)
            let endDateText = task.recurrenceEndDate != nil ? " until \(formatter.string(from: task.recurrenceEndDate!))" : ""
            return "Monthly on the \(ordinal) \(weekdayName)\(endDateText)"
        }
    }
  
  func dueDateText(for task: task) -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = "MMM dd, yyyy" // Format for displaying the date
      if let due_date = task.date_due {
        return formatter.string(from: due_date)
      } else {
        return "No due dates for recurring tasks"
      }
  }
  
  func createdDateText(for task: task) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM.dd.yy h:mm a"
    
     // Format for displaying the date
    if let create_date = task.date_created {
      guard let date = formatter.date(from: create_date) else {return "Invalid Date"}
      formatter.dateFormat = "MMM dd, yyyy"
      
      return formatter.string(from: date)
      
    } else {
      return "No Date Provided"
    }
  }

    func ordinalWeekday(for date: Date) -> (String, String) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday, .weekdayOrdinal], from: date)
        guard let weekday = components.weekday, let ordinal = components.weekdayOrdinal else {
            return ("", "")
        }
        let formatter = DateFormatter()
        let weekdayName = formatter.weekdaySymbols[weekday - 1] // Adjusting for index
        let ordinalSuffix = ["first", "second", "third", "fourth", "last"]
        let ordinalIndex = min(ordinal - 1, ordinalSuffix.count - 1) // Adjust for array index and limit to 'last'
        return (ordinalSuffix[ordinalIndex], weekdayName)
    }
}
  
  



struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(currUser: UserViewModel.mockUser(), currTask: TaskViewModel.mockTask())
            .environmentObject(TaskViewModel())
            .environmentObject(UserViewModel())
    }
}

