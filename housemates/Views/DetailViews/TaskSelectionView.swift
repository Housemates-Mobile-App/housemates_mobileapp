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
    @State private var filteredHouseworkTaskData : [TaskData] = hardcodedHouseworkTaskData
    @State private var filteredIndoorTaskData : [TaskData] = hardcodedIndoorTaskData
    @State private var filteredOutdoorTaskData : [TaskData] = hardcodedOutdoorTaskData
    var allTaskData : [TaskData] = hardcodedHouseworkTaskData + hardcodedIndoorTaskData + hardcodedOutdoorTaskData
    
    let user : User
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                Text("Select Task")
                    .font(.custom("Nunito-Bold", size: 26))
                    .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                    
                    .padding(.top)
                ScrollView(.vertical, showsIndicators: false) {
                    // MARK: Search bar for preset tasks
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding([.top, .bottom], 5)
                            .padding(.leading, 10)
                        
                        TextField("What task do you want to add?", text: $searchTask)
                            .font(.custom("Lato", size: 14))
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
                    
                    taskCategoryView(categoryName: "Housework", taskData: filteredHouseworkTaskData)
                    taskCategoryView(categoryName: "Indoor", taskData: filteredIndoorTaskData)
                    taskCategoryView(categoryName: "Outdoor", taskData: filteredOutdoorTaskData)
                    
                }
                Spacer()
                
                NavigationLink(destination: AddTaskView(taskIconStringHardcoded: "", taskNameHardcoded: "", user: user, showTaskSelectionView: $showTaskSelectionView)) {
                    Text("Add a Custom Task +")
                        .font(.custom("Nunito-Bold", size: 18))
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
      VStack() {
            Text(categoryName)
                .font(.custom("Lato-Bold", size: 14))
             
                .padding()
                .lineLimit(1)
                .frame(width: (UIScreen.main.bounds.width - 25), alignment: .leading)
            
            if (taskData.count == 0) {
                Text("No \(categoryName.lowercased()) templates to display")
                    .padding()
                    .font(.custom("Lato-Regular", size: 12))
                    .foregroundColor(.gray)
            }
            else {
                ForEach(0..<taskData.count, id: \.self) { i in
                    if i % 3 == 0 {
                      HStack(spacing: 0) {
                       
                            ForEach(0..<min(3, taskData.count - i), id: \.self) { j in
                                NavigationLink(destination: AddTaskView(taskIconStringHardcoded: taskData[i + j].taskIcon, taskNameHardcoded: taskData[i + j].taskName, user: user, showTaskSelectionView: $showTaskSelectionView)) {
                                    TaskSelectionBox(taskIconString: taskData[i + j].taskIcon, taskName: taskData[i + j].taskName)
                                    .frame(width: (UIScreen.main.bounds.width - 25) / 3)
                                }
                            }
                        
//                        adds plcaceholder to fix spacing when filetering tasks
                        if taskData.count - i < 3 {
                            ForEach(0..<(3 - (taskData.count - i)), id: \.self) { _ in
                                Rectangle()
                                    .foregroundColor(Color.clear) // Invisible
                                    .frame(width: (UIScreen.main.bounds.width - 25) / 3)
                            }
                        }
                           
                        }.frame(width: UIScreen.main.bounds.width - 25)
                    }
                }
            }
        }
    }
    
    private func search(searchText: String, CategoryHardcodedTaskData: [TaskData]) -> [TaskData] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return CategoryHardcodedTaskData
        } else {
            return CategoryHardcodedTaskData.filter { tempTaskData in
                return tempTaskData.taskName.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
   
    
}

struct TaskSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TaskSelectionView(showTaskSelectionView: Binding.constant(false), user: UserViewModel.mockUser())
            .environmentObject(TaskViewModel())
    }
}
