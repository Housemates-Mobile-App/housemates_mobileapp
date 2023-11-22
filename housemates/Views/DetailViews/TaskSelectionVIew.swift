//
//  TaskSelectionVIew.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/10/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct TaskSelectionView: View {
    @EnvironmentObject var taskViewModel : TaskViewModel
    @Binding var showTaskSelectionView: Bool
    @State private var searchTask: String = ""
    @State private var filteredHouseworkTaskData : [TaskData] = []
    @State private var filteredIndoorTaskData : [TaskData] = []
    @State private var filteredOutdoorTaskData : [TaskData] = []
    var allTaskData : [TaskData] = hardcodedHouseworkTaskData + hardcodedIndoorTaskData + hardcodedOutdoorTaskData
    
    let user : User
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                Text("Select Task")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                ScrollView(.vertical, showsIndicators: false) {
                    // MARK: Search bar for preset tasks
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(5)
                        
                        TextField("What task do you want to add?", text: $searchTask)
                            .font(.system(size: 14))
                            .foregroundColor(Color.black)
                            .padding(.vertical, 10)
                            .background(Color.clear)
                            .onChange(of: searchTask, perform: { value in
                                filteredHouseworkTaskData = search(searchText: searchTask, CategoryHardcodedTaskData: hardcodedHouseworkTaskData)
                                filteredIndoorTaskData = search(searchText: searchTask, CategoryHardcodedTaskData: hardcodedIndoorTaskData)
                                filteredOutdoorTaskData = search(searchText: searchTask, CategoryHardcodedTaskData: hardcodedOutdoorTaskData)
                            })
                    }
                    .background(Color(.systemGray5))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    taskCategoryView(categoryName: "Housework", taskData: displayTaskDatas(searchText: searchTask, allTaskData: allTaskData, CategoryHardcodedTaskData: filteredHouseworkTaskData))
                    taskCategoryView(categoryName: "Indoor", taskData: displayTaskDatas(searchText: searchTask, allTaskData: allTaskData, CategoryHardcodedTaskData: filteredIndoorTaskData))
                    taskCategoryView(categoryName: "Outdoor", taskData: displayTaskDatas(searchText: searchTask, allTaskData: allTaskData, CategoryHardcodedTaskData: filteredOutdoorTaskData))
                    
                }
                Spacer()
                
                NavigationLink(destination: AddTaskView(taskIconStringHardcoded: "", taskNameHardcoded: "", user: user, showTaskSelectionView: $showTaskSelectionView)) {
                    Text("Add a Custom Task +")
                        .font(.system(size: 18))
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color(red: 0.439, green: 0.298, blue: 1.0))
                        .cornerRadius(30)
                        .padding(.horizontal)
                }
                .buttonStyle(PlainButtonStyle())
                
            }
        }
    }
        
    // Function to generate task selection content for a category
    private func taskCategoryView(categoryName: String, taskData: [TaskData]) -> some View {
        VStack {
            Text(categoryName)
                .font(.system(size: 14))
                .bold()
                .padding(.top)
            
            ForEach(0..<taskData.count, id: \.self) { i in
                if i % 3 == 0 {
                    HStack {
                        ForEach(0..<min(3, taskData.count - i), id: \.self) { j in
                            NavigationLink(destination: AddTaskView(taskIconStringHardcoded: taskData[i + j].taskIcon, taskNameHardcoded: taskData[i + j].taskName, user: user, showTaskSelectionView: $showTaskSelectionView)) {
                                TaskSelectionBox(taskIconString: taskData[i + j].taskIcon, taskName: taskData[i + j].taskName)
                            }
                        }
                        Spacer()
                    }.frame(width: UIScreen.main.bounds.width - 25)
                }
            }
        }
    }
    
    private func search(searchText: String, CategoryHardcodedTaskData: [TaskData]) -> [TaskData] {
       return CategoryHardcodedTaskData.filter { tempTaskData in
         return tempTaskData.taskName.lowercased().contains(searchText.lowercased())
       }
     }
    
    func displayTaskDatas(searchText: String, allTaskData: [TaskData], CategoryHardcodedTaskData: [TaskData]) -> [TaskData] {
        if searchText == "" {
          return allTaskData
        } else {
         return CategoryHardcodedTaskData
        }
    }
    
}

struct TaskSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TaskSelectionView(showTaskSelectionView: Binding.constant(false), user: UserViewModel.mockUser())
            .environmentObject(TaskViewModel())
    }
}
