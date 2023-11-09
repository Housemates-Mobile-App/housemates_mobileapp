//
//  TaskBoardView.swift
//  housemates
//
//  Created by Sean Pham on 11/2/23.
//

import SwiftUI

//struct TaskBoardView: View {
//    @EnvironmentObject var taskViewModel : TaskViewModel
//    @EnvironmentObject var authViewModel : AuthViewModel
//
//    var body: some View {
//            if let user = authViewModel.currentUser {
//                VStack() {
//                    Text("Task Board")
//                        .font(.largeTitle)
//                        .padding(.bottom, 10)
//                    
//                    Section("Daily Tasks") {
//                        ForEach(taskViewModel.getTasksForGroup(user.group_id!)) { task in
//                            // TODO: refactor TaskView to take in only a task and then case on fields of the task
//                            TaskView(task: task, unclaimed: false, inProgressOther: true, inProgressSelf: false)
//                        }
//                    }
//                }
//            }
//            
//        }
//    }


struct TaskBoardView: View {
    @EnvironmentObject var taskViewModel : TaskViewModel
    @EnvironmentObject var authViewModel : AuthViewModel
   
        
    // Placeholder user data
    let users = ["sean", "sanmoy", "bernie", "gunawan"]
    
    var body: some View {
        NavigationView {
            ScrollView {
              if let user = authViewModel.currentUser {
                VStack() {
                  HStack {
                    Text("Task Board")
                      .font(.largeTitle)
                      .fontWeight(.bold)
                    
                    Spacer()
                    
                    //                            Button(action: {
                    //                                // Action for adding a task
                    //                            })
                    NavigationLink(destination: AddTaskView(user: user, taskViewModel: taskViewModel)) {
                      Text("+ Add")
                        .fontWeight(.semibold)
                    }
                  }
                  .padding(.horizontal)
                  
                  // Users who are free
                  HStack {
                    Text("Who's Free?")
                      .font(.headline)
                      .padding(.vertical)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                      HStack {
                        //                                    ForEach(users.filter { $0.isFree }) { user in
                        //                                        Text(user.name)
                        //                                            .padding(.all, 5)
                        //                                            .background(Capsule().fill(Color.green))
                        Text("sean")
                          .padding(.all, 5)
                          .background(Capsule().fill(Color.green))
                      }
                    }
                  }
                  .padding(.horizontal)
                  
                  // Daily Tasks Section
                  VStack(alignment: .leading) {
                    Text("Unclaimed")
                      .font(.title2)
                      .padding(.vertical)
                    
                    ForEach(taskViewModel.getUnclaimedTasksForGroup(user.group_id!)) { task in
                      // TODO: refactor TaskView to take in only a task and then case on fields of the task
                      TaskView(task: task, user: user)
                    }
                  }
                  .padding(.horizontal)
                  
                  // Recurring Tasks Section
                  VStack(alignment: .leading) {
                    Text("In Progress")
                      .font(.title2)
                      .padding(.vertical)
                    
                    ForEach(taskViewModel.getInProgressTasksForGroup(user.group_id!)) { task in
                      // TODO: refactor TaskView to take in only a task and then case on fields of the task
                      TaskView(task: task, user: user)
                    }
                    
                  }
                  .padding(.horizontal)
                  
                  VStack(alignment: .leading) {
                    Text("Completed")
                      .font(.title2)
                      .padding(.vertical)
                    
                    ForEach(taskViewModel.getCompletedTasksForGroup(user.group_id!)) { task in
                      // TODO: refactor TaskView to take in only a task and then case on fields of the task
                      TaskView(task: task, user: user)
                      
                    }
                  }
                  .padding(.horizontal)
                }
                .navigationBarItems(
                  leading: EditButton()
                  
                  
                  //                        ,trailing: Button(action: {
                  //                            // Action for adding a task
                  //                        }) {
                  //                            Image(systemName: "plus")
                  //                        }
                )
                
                Spacer()
                
              }
            }
        }
    }
}


struct TaskBoardView_Previews: PreviewProvider {
    static var previews: some View {
        TaskBoardView()
    }
}
