import SwiftUI

struct TaskBoardView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var tabBarViewModel : TabBarViewModel
//    @State private var selected: String = "All Tasks"
    @State private var isAnimating = false
    @State private var selectedDate : Date? = nil
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
    private var unknownDate = Date.distantPast
    
    init() {
        let appear = UINavigationBarAppearance()

        let atters: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Nunito-Bold", size: 26)!,
            .foregroundColor: UIColor(red: 0.439, green: 0.298, blue: 1.0, alpha: 1.0)
        ]
        
        appear.largeTitleTextAttributes = atters
        appear.titleTextAttributes = atters
        UINavigationBar.appearance().standardAppearance = appear
     }

    var body: some View {
        // Check for current user
        if let user = authViewModel.currentUser {
            NavigationStack {
                VStack {
                    // Header Section
//                    taskHeader(user: user)

                    // Main Content Section
                    mainContent(user: user)

                }
                    .padding(.top, 10)
                    .navigationTitle("Tasks")
                    .navigationBarTitleDisplayMode(.inline)
                    .coordinateSpace(name: "scroll")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            addTaskButton(user: user)
                            
                        }
                    }
                    .onAppear {
                        tabBarViewModel.hideTabBar = false
                    }
            }
        }
    }

    // Task Header View
    private func taskHeader(user: User) -> some View {
        HStack {
            headerTitle()
            Spacer()
            addTaskButton(user: user)
        }
    }

    // Header Title
    private func headerTitle() -> some View {
        Text("Tasks")
            .font(.custom("Nunito-Bold", size: 26))
            .font(.title)
            .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
    }

    // Add Task Button
    private func addTaskButton(user: User) -> some View {
        Button(action: {
                tabBarViewModel.showTaskSelectionView = true
           }) {
               Image(systemName: "plus")
                   .font(.custom("Lato-Bold", size: 15))
                   .imageScale(.small)
                   .foregroundColor(Color.white)
                   .padding(7.5)
                   .background(Circle().fill(Color(red: 0.439, green: 0.298, blue: 1.0)).frame(width: 24, height: 24))
                   .fontWeight(.semibold)
           }.padding(.bottom, 6)
            .padding(.trailing, 5)
    }

    // Main Content Section
    private func mainContent(user: User) -> some View {
      VStack {
          CalendarView(selectedDate: $selectedDate)
          taskSections(user: user, selectedDate: selectedDate)
        }
      }

 
    // Task Sections
    private func taskSections(user: User, selectedDate: Date?) -> some View {
      let unclaimedTasks = taskViewModel.getUnclaimedTasksForGroup(user.group_id)
      let completedTasks = taskViewModel.getCompletedTasksForGroup(user.group_id)
      let inProgressTasks = taskViewModel.getInProgressTasksForGroup(user.group_id)
      
      let inProgressTasksSorted = inProgressTasks.sorted {
          guard let date1 = getFullDate(dateStr: $0.date_created ?? ""),
                let date2 = getFullDate(dateStr: $1.date_created ?? "") else {
              return false
          }
          return date1 > date2
      }
      
      let inProgressTasksForCurrentUser = inProgressTasksSorted.filter { $0.user_id == user.user_id }
      let inProgressTasksForOtherUsers = inProgressTasksSorted.filter { $0.user_id != user.user_id }
        
      // filtering by date if necessary
        print(selectedDate)
        print(unclaimedTasks)
    let filteredUnclaimedTasks = selectedDate != nil ?
        unclaimedTasks.filter { $0.date_due!.isSameDay(as: selectedDate!) } :
            unclaimedTasks
        
    let filteredInProgressTasksForCurrentUser = selectedDate != nil ?
        inProgressTasksForCurrentUser.filter { $0.date_due!.isSameDay(as: selectedDate!) } :
        inProgressTasksForCurrentUser
        
    let filteredInProgressTasksForOtherUsers = selectedDate != nil ?
        inProgressTasksForOtherUsers.filter { $0.date_due!.isSameDay(as: selectedDate!) } :
        inProgressTasksForOtherUsers
        
    let filteredCompletedTasks = selectedDate != nil ?
        completedTasks.filter { getFullDate(dateStr: $0.date_completed ?? "")!.isSameDay(as: selectedDate!) } :
        completedTasks
      
      
      return List {
          Section(header: Text("Unclaimed")
            .font(.custom("Nunito-Bold", size: 16))
            .foregroundColor(.primary)) {
            if (unclaimedTasks.count == 0) {
                Text("No unclaimed tasks to display")
                    .font(.custom("Lato-Regular", size: 12))
                    .foregroundColor(.gray)
                    .listRowSeparator(.hidden)
            }
            else {
                ForEach(filteredUnclaimedTasks) { task in
                    
                    ZStack {
                        NavigationLink(destination: TaskDetailView(currUser: user, currTask:task)) {
                        }
                        .opacity(0)
                        
                        taskRow(task: task, user: user)
                        
                    }.listRowSeparator(.hidden)
                }
            }
          }

          Section(header: Text("In Progress")
            .font(.custom("Nunito-Bold", size: 16))
            .foregroundColor(.primary)
          
          ) {
              if (inProgressTasks.count == 0) {
                  Text("No in progress tasks to display")
                      .font(.custom("Lato-Regular", size: 12))
                      .foregroundColor(.gray)
                      .listRowSeparator(.hidden)
              }
              else {
                  ForEach(filteredInProgressTasksForCurrentUser) { task in
                      ZStack {
                          NavigationLink(destination: TaskDetailView(currUser: user, currTask:task)) {
                              //                        gets rid of the arrow icon
                              
                          }
                          .opacity(0)
                          
                          taskRow(task: task, user: user)
                          
                      }.listRowSeparator(.hidden)
                  }
                  ForEach(filteredInProgressTasksForOtherUsers) { task in
                      ZStack {
                          NavigationLink(destination: TaskDetailView(currUser: user, currTask:task)) {
                              //                        gets rid of the arrow icon
                              
                          }
                          .opacity(0)
                          
                          taskRow(task: task, user: user)
                          
                      }.listRowSeparator(.hidden)
                  }
              }
          }
        
          Section(header: Text("Completed")
            .font(.custom("Nunito-Bold", size: 15))
            .foregroundColor(.primary)) {
              if (completedTasks.count == 0) {
                  Text("No completed tasks to display")
                      .font(.custom("Lato-Regular", size: 12))
                      .foregroundColor(.gray)
                      .listRowSeparator(.hidden)
              }
              else {
                  if selectedDate == nil {
                      ForEach (convertCompletedList(completedList: filteredCompletedTasks), id: \.0) { date, tasks in
                          HStack {
                              Text(convertDateToStr(date: date)).font(.custom("Lato-Regular", size: 12))
                                  .foregroundColor(.gray)
                              Spacer()
                          }
                          ForEach(tasks, id: \.id) { task in
                              ZStack {
                                  NavigationLink(destination: TaskDetailView(currUser: user, currTask:task)) {
                                  }
                                  .opacity(0)
                                  taskRow(task: task, user: user)
                                  
                              }.listRowSeparator(.hidden)
                          }
                      }.listRowSeparator(.hidden)
                  } else {
                      ForEach(filteredCompletedTasks) { task in
                          ZStack {
                              NavigationLink(destination: TaskDetailView(currUser: user, currTask:task)) {
                                  
                              }
                              .opacity(0)
                              
                              taskRow(task: task, user: user)
                              
                          }.listRowSeparator(.hidden)
                      }
                  }
              }
          }
      }
//      .listStyle(.plain)
      .listStyle(PlainListStyle())
      .padding(.bottom, 45)
  }


    // Individual Task Section
  private func taskRow(task: task, user: User) -> some View {
      TaskView(task: task, user: user)
    
//      .blur(radius: isAnimating && taskViewModel.recentID == task.id ? 0 : 5)
//      .onAppear {
//        if taskViewModel.recentID == task.id {
//          isAnimating = true
//          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            isAnimating = false
//          }
//        }
//          
//      }
//      .rotationEffect(.degrees(isAnimating && taskViewModel.recentID == task.id ? 45 : 0))
    
      .shadow(color: deepPurple.opacity(isAnimating && taskViewModel.recentID == task.id ? 0.75 : 0), radius: 5, x: 0, y: 0)
                  .animation(Animation.easeInOut(duration: 1), value: isAnimating)
                  
            .onAppear {
              if taskViewModel.recentID == task.id {
                isAnimating = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                  isAnimating = false
                }
              }
                
            }
//      .overlay(
//        
//          RoundedRectangle(cornerRadius: 5)
//            
//            .trim(from: 0, to: taskViewModel.recentID == task.id && isAnimating ? 1 : 0)
//              .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round))
//              .foregroundColor(deepPurple) // Use your desired color
//              .animation(Animation.linear(duration: 1), value: isAnimating)
//              
//      )
//      .onAppear {
//          if taskViewModel.recentID == task.id {
//              isAnimating = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                  isAnimating = false
//              }
//          }
//      }
          .swipeActions {
           
          
            if let user_id = user.id {
              
            
              
              if task.status == .unclaimed || (task.status == .inProgress && task.user_id == user_id) {
              
              
                Button(role: .destructive) {
                  taskViewModel.destroy(task: task)
                } label: {
                  Label("Delete", systemImage: "trash")
                }
              }
                
            
            
              if task.status == .inProgress && task.user_id == user_id {
                
                
                Button() {
                  taskViewModel.undoTask(task: task, user_id: user_id)
                } label: {
                  Label("Claim", systemImage: "arrowshape.turn.up.backward.fill")
                  
                }.tint(Color(red: 0.439, green: 0.298, blue: 1.0))
                  
              }
            }
            
            
          }
    }
    
    // just d,m,y info for keys
    private func getPartialDate(dateStr: String) -> Date? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM.dd.yy h:mm a"
        
        guard let dateFromStr = dateFormatter.date(from: dateStr) else {
            return nil
        }
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: dateFromStr)
        let month = calendar.component(.month, from: dateFromStr)
        let day = calendar.component(.day, from: dateFromStr)
        return calendar.date(from: DateComponents(year: year, month: month, day: day))
    }
    
    // d,m,y,h,s info
    private func getFullDate(dateStr: String) -> Date? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM.dd.yy h:mm a"
        return dateFormatter.date(from: dateStr)
    }
    
    private func convertCompletedList(completedList: [task]) -> [(Date, [task])] {
        var completedDict: [Date: [task]] = [:]

        for cTask in completedList {
            let dateStr = cTask.date_completed!
            let partialDate = getPartialDate(dateStr: dateStr) ?? unknownDate

            if completedDict[partialDate] != nil {
                completedDict[partialDate]!.append(cTask)
            } else {
                completedDict[partialDate] = [cTask]
            }
        }

        // Sort the dictionary by descending date
        let sortedTasks = completedDict.sorted { $0.key > $1.key }
            .map { (date: $0.key, tasks: $0.value.sorted { task1, task2 in
                getFullDate(dateStr: task1.date_completed!) ?? Date() > getFullDate(dateStr: task2.date_completed!) ?? Date()
            }) }
        
        // note: this doesnt sort tasks on a particular day, which i think is fine
        return sortedTasks
    }
    
    private func convertDateToStr(date: Date) -> String {
        if date == unknownDate {
            return "Unknown Day, Unknown Date"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM d"
            return dateFormatter.string(from: date)
        }
    }
}



struct TaskBoardView_Previews: PreviewProvider {
    static var previews: some View {
        TaskBoardView()
            .environmentObject(AuthViewModel.mock())
            .environmentObject(TaskViewModel())
            .environmentObject(UserViewModel())
    }
}
