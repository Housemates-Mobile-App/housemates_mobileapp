import SwiftUI

struct TaskBoardView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var tabBarViewModel : TabBarViewModel
    @EnvironmentObject var weekStore: WeekStore
//    @State private var selected: String = "All Tasks"
    @State private var isAnimating = false
    
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
//            // Debugging selectedDate
//            Text("Selected Date: \(weekStore.selectedDate?.formatted() ?? "nil")")
//            
//            // Debugging pseudoSelectedDate
//            Text("Pseudo Selected Date: \(weekStore.pseudoSelectedDate.formatted())")

    VStack(spacing: 0) {
        TaskCalendarView()
        taskSections(user: user, selectedDate: weekStore.selectedDate)
    }
            
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
        let filteredUnclaimedTasks = weekStore.selectedDate != nil ?
            unclaimedTasks.filter { $0.date_due?.isSameDay(as: weekStore.selectedDate!) ?? false } :
            unclaimedTasks

        
    let filteredInProgressTasksForCurrentUser = weekStore.selectedDate != nil ?
        inProgressTasksForCurrentUser.filter { $0.date_due?.isSameDay(as: weekStore.selectedDate!) ?? false } :
        inProgressTasksForCurrentUser
        
    let filteredInProgressTasksForOtherUsers = weekStore.selectedDate != nil ?
        inProgressTasksForOtherUsers.filter { $0.date_due?.isSameDay(as: weekStore.selectedDate!) ?? false} :
        inProgressTasksForOtherUsers
        
    let filteredCompletedTasks = weekStore.selectedDate != nil ?
        completedTasks.filter { getFullDate(dateStr: $0.date_completed ?? "")!.isSameDay(as: weekStore.selectedDate!) } :
        completedTasks
      
        if (filteredUnclaimedTasks.count == 0 && filteredInProgressTasksForCurrentUser.count == 0 && filteredInProgressTasksForOtherUsers.count == 0 && filteredCompletedTasks.count == 0) {
            return AnyView(emptyTasksView())
        }
        else {
            return AnyView(
                List {
                    Section(header: HStack {
                        Text("Unclaimed")
                            .font(.custom("Nunito-Bold", size: 16))
                            .foregroundColor(.primary)
                        Circle()
                            .fill(Color(red: 0.835, green: 0.349, blue: 1.0))
                            .frame(maxWidth: 13)
                    })
                     {
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
                
                Section(header: HStack {
                        Text("In Progress")
                            .font(.custom("Nunito-Bold", size: 16))
                            .foregroundColor(.primary)
                        Circle()
                            .fill(Color(red: 1.0, green: 0.925, blue: 0.302))
                            .frame(maxWidth: 13)
                    }
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
                    .font(.custom("Nunito-Bold", size: 16))
                    .foregroundColor(.primary)) {
                        if (completedTasks.count == 0) {
                            Text("No completed tasks to display")
                                .font(.custom("Lato-Regular", size: 12))
                                .foregroundColor(.gray)
                                .listRowSeparator(.hidden)
                        }
                        else {
                            if weekStore.selectedDate == nil {
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
        )}
  }

    private func emptyTasksView() -> some View {
        ScrollView(.vertical, showsIndicators:false) {
            VStack {
                Image("sadhouse")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .padding(.top, 30)
                    .padding(.leading, 20)
                Text("No tasks here")
                    .font(.custom("Nunito-Bold", size: 24))
                Text("Try selecting a different date, or add a new task")
                    .font(.custom("Lato-Bold", size: 12))
                    .foregroundColor(.gray)
                Spacer()
            }
        }
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
    
      .shadow(color: deepPurple.opacity(isAnimating && taskViewModel.recentID == task.id ? 1 : 0), radius: 7, x: 0, y: 0)
      .animation(Animation.easeOut(duration: 0.2), value: isAnimating)
                  
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
