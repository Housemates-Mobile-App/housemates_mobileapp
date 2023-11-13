//
//  TaskBoardView.swift
//  housemates
//
//  Created by Sean Pham on 11/2/23.
//

import SwiftUI

struct TaskBoardView: View {
    @EnvironmentObject var taskViewModel : TaskViewModel
    @EnvironmentObject var authViewModel : AuthViewModel
  
    @State private var selectedTab = 0
    @Binding var hideTabBar: Bool
    @State private var progress = 0.0
    private let animationDuration = 1.0
    @State private var selected: String = "All Tasks"
  
    
  
   
    
    var body: some View {
   
      if let user = authViewModel.currentUser {
        
        NavigationView {
          
          //            contains the task board
          VStack() {
            HStack {
              
              Text("Tasks")
                
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor((Color(red: 0.439, green: 0.298, blue: 1.0)))
                
              
              Spacer()
              
              EditButton().padding(.horizontal).fontWeight(.semibold)
//              Button(action: {
//                if self.progress <= 0.75 {
//                  self.progress += 0.25
//                }
//                
//              }) {
//                Text("hi")
//              }
//              Button(action: {
//                if self.progress >= 0.25 {
//                  self.progress -= 0.25
//                }
//                
//              }) {
//                Text("bye")
//              }
              
              NavigationLink(destination: TaskSelectionView(user: user, hideTabBar: $hideTabBar, selectedTab: $selectedTab)) {
                Text("+")
                  .font(.title)
                  .padding(7.5)
                  .clipShape(Circle())
                  .fontWeight(.semibold)
                  .foregroundColor(Color.white)
                  .background(Circle().fill(Color(red: 0.439, green: 0.298, blue: 1.0)))
                    
                  
              }
            }
            .padding()
            
            
            
            //              allows for swiping
            TabView(selection: $selectedTab) {
              
              ScrollView {
                VStack(alignment: .leading) {
                  HStack {
                    Spacer()
                    let percent = Int(self.progress * 100)
                    Text(String(percent) + "%")
                      .font(.title)
                      .foregroundColor((Color(red: 0.439, green: 0.298, blue: 1.0)))
                      .bold()
                    Spacer()
                  }
                  
                  ZStack(alignment: .leading) {
                    // Background Capsule
                    Capsule() // Background
                      .frame(width: UIScreen.main.bounds.width - 75, height: 30)
                      .foregroundColor(Color.gray.opacity(0.0))
                      .overlay(
                        Capsule().stroke(Color.black.opacity(0.25), lineWidth: 2)
                      )
                      .offset(x: 35, y: 0)
                    
                    // Foreground Capsule
                    Capsule() // Animated Foreground
                      .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 0.439, green: 0.298, blue: 1.0).opacity(0.5), Color.purple.opacity(0.5), Color.pink.opacity(0.5)]),
                                           startPoint: .leading, endPoint: .trailing))
                      .frame(width: max(CGFloat(self.progress) * (UIScreen.main.bounds.width - 75), 0), height: 30)
                      .offset(x: 35, y: 0)
                      .animation(.easeInOut(duration: animationDuration))
                  }
                  
                  
                  FilterView(selected: $selected)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 25)
                  
                  //
                  
                  
                  if (selected == "Todo" || selected == "All Tasks") {
                    
                    VStack(alignment: .leading) {
                      Text("Todo")
                        .font(.headline)
                        .padding(.top)
                        .bold()
                      
                      let unclaimedTasks = taskViewModel.getUnclaimedTasksForGroup(user.group_id!)
                      if unclaimedTasks.isEmpty {
                        MessageCardView(message: "All Tasks Complete")
                      }
                      ForEach(unclaimedTasks) { task in
                        TaskView(task: task, user: user, progress: $progress)
                      }
                      
                      
                    }
                    .padding(.horizontal)
                  }
                }
                
                // Recurring Tasks Section
                if (selected == "Doing" || selected == "All Tasks") {
                  
                  VStack(alignment: .leading) {
                    
                    Text("In Progress")
                      .font(.headline)
                      .padding(.top)
                    
                      .bold()
                    
                    let inProgressTasks = taskViewModel.getInProgressTasksForGroup(user.group_id!)
                    if inProgressTasks.isEmpty {
                      MessageCardView(message: "No Tasks in Progress")
                    }
                    ForEach(inProgressTasks) { task in
                      TaskView(task: task, user: user, progress: $progress)
                    }
                    
                  }
                  .padding(.horizontal)
                }
              
                
                
                if (selected == "Completed" || selected == "All Tasks") {
                  
                VStack(alignment: .leading) {
                  Text("Completed")
                    .padding(.top)
                    .font(.headline)
                  
                    .bold()
                  
                  let completedTasks = taskViewModel.getCompletedTasksForGroup(user.group_id!)
                  if completedTasks.isEmpty {
                    MessageCardView(message: "No Completed Tasks")
                  }
                  ForEach(completedTasks) { task in
                    TaskView(task: task, user: user, progress: $progress)
                  }
                }
                .tag(0)
                .padding(.horizontal)
              }
              }
              
              GraphView()
                .tag(1)
              
              
              
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            Spacer()
            
            
          }.background(
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.15),  Color.purple.opacity(0.15)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                           .frame(maxWidth: .infinity, maxHeight: .infinity)
                           .edgesIgnoringSafeArea(.all))
          .onAppear {
            let numCompleted = taskViewModel.getNumCompletedTasksForGroup(user.group_id!)
            progress = Double(numCompleted) / 10.0
            progress = min(progress, 1.0)
          }
            
            
            
          
        }
          
        }
      }
    
}


struct TaskBoardView_Previews: PreviewProvider {
    static var previews: some View {
        TaskBoardView(hideTabBar: Binding.constant(false))
            .environmentObject(AuthViewModel.mock())
            .environmentObject(TaskViewModel())
            .environmentObject(UserViewModel())
    }
    
}
