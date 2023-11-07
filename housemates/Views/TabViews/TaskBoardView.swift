//
//  TaskBoardView.swift
//  housemates
//
//  Created by Sean Pham on 11/2/23.
//

import SwiftUI

struct TaskBoardView: View {
    @ObservedObject var taskViewModel = TaskViewModel()
    @ObservedObject var authViewModel = AuthViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Task Board")
                .font(.largeTitle)
                .padding(.bottom, 10)
            
            if let currentUser = authViewModel.currentUser {
                VStack(alignment: .leading) {
                    Text("Daily")
                        .font(.title)
                    ForEach(taskViewModel.userTasks) { task in
                        TaskView(task: task, unclaimed: false, inProgressOther: true, inProgressSelf: false)
                    }
                }
                // Repeat for recurring
            } else {
                Text("Please log in to see tasks.")
            }
            Spacer()
            
            //        VStack(alignment: .leading) {
            //          Text("Daily")
            //            .font(.title)
            //          TaskView(unclaimed: false, inProgressOther: true, inProgressSelf: false)
            //          TaskView(unclaimed: true, inProgressOther: false, inProgressSelf: false)
            //
            //        }
                .onAppear {
                    Task{
                        if let userID = authViewModel.currentUser?.id {
                            await taskViewModel.fetchUserTasks(userID)
                        }
                    }
                }
            //        VStack(alignment: .leading) {
            //          Text("Recurring")
            //            .font(.title)
            ////          TaskView(unclaimed: false, inProgressOther: false, inProgressSelf: true)
            ////          TaskView(unclaimed: false, inProgressOther: true, inProgressSelf: false)
            //        }
            //        Spacer()
            
        }
    }
    
    
    
    
    struct TaskBoardView_Previews: PreviewProvider {
        static var previews: some View {
            TaskBoardView(taskViewModel: TaskViewModel(), authViewModel: AuthViewModel())
        }
    }
}
