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

    var body: some View {
            if let user = authViewModel.currentUser {
                VStack() {
                    Text("Task Board")
                        .font(.largeTitle)
                        .padding(.bottom, 10)
                    
                    Section("Daily Tasks") {
                        ForEach(taskViewModel.getTasksForGroup(user.group_id!)) { task in
                            // TODO: refactor TaskView to take in only a task and then case on fields of the task
                            TaskView(task: task, unclaimed: false, inProgressOther: true, inProgressSelf: false)
                        }
                    }
                }
            }
            
        }
    }
