//
//  TaskSelectionVIew.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/10/23.
//

import SwiftUI

struct TaskSelectionView: View {
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    Text("Add Task")
                        .font(.system(size: 40))
                        .bold()
                        .foregroundColor(.white)
                    Divider()
                        .background(Color.white)
                    // Search bar placeholder
                    TextField("Search for a template...", text: .constant(""))
                        .font(.system(size: 20))
                        .padding(.vertical)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .frame(width: 370)
                    VStack {
                        ForEach(0..<hardcodedTaskData.count, id: \.self) { i in
                            if i % 3 == 0 {
                                HStack {
                                    ForEach(0..<min(3, hardcodedTaskData.count - i), id: \.self) { j in
                                        TaskSelectionBox(taskIconString: hardcodedTaskData[i + j].taskIcon, taskName: hardcodedTaskData[i + j].taskName)
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
            .padding(.top, 50)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color(red: 234/255, green: 64/255, blue: 128/255), Color(red: 1, green: 88/255, blue: 88/255)]), startPoint: .top, endPoint: .bottom)
            )
            .edgesIgnoringSafeArea(.all)

            // Oval-shaped button at the bottom
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 100)
                    .fill(Color(red: 194/255, green: 0/255, blue: 73/255))
                    .frame(width: 480, height: 167)
                    .overlay(
                        Text("Add a Custom Task +")
                            .font(.system(size: 25))
                            .bold()
                            .foregroundColor(.white)
                            .offset(y: -40)
                        
                    )
                    .padding(.bottom,-60)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct TaskSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TaskSelectionView()
    }
}
