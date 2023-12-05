//
//  HousemateProfileView.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/2/23.
//

import SwiftUI
import Charts

struct HousemateProfileView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var taskViewModel : TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    let housemate: User
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
    var body: some View {
        let recentTasks = taskViewModel.getRecentCompletedTasksForUser(housemate.id ?? "")
        ZStack {
            //wave
            VStack {
                NewWave()
                    .fill(deepPurple)
                    .frame(height: 170)
                Spacer()
            }.edgesIgnoringSafeArea(.top)
            
            VStack(spacing: 30) {
                VStack(alignment: .center) {
//                    Image(systemName:"gear")
//                        .foregroundColor(.clear)
//                        .font(.system(size: 18))
//                        .padding()
                    //image
                    let imageURL = URL(string: housemate.imageURLString ?? "")
                    
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } placeholder: {
                        // Default user profile picture
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(red: 0.6, green: 0.6, blue: 0.6), Color(red: 0.8, green: 0.8, blue: 0.8)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text("\(housemate.first_name.prefix(1).capitalized + housemate.last_name.prefix(1).capitalized)")
                                
                                    .font(.custom("Nunito-Bold", size: 40))
                                    .foregroundColor(.white)
                            )
                    }
                    
                    Text("\(housemate.first_name) \(housemate.last_name)")
                        .font(.system(size: 26))
                        .bold()
                        .foregroundColor(.black)
                    
                    HStack(spacing: 20) {
                        HousemateProfileButton(phoneNumber: housemate.phone_number, title: "Call", iconStr: "phone.fill", urlScheme:"tel")
                        HousemateProfileButton(phoneNumber: housemate.phone_number, title: "Text", iconStr: "message.fill", urlScheme:"sms")
                    }
                }.padding(.top, 28)
                
                VStack (spacing: 25) {
                    VStack(spacing: 10) {
                        HStack() {
                            Text("Task Stats")
                                .font(.custom("Lato-Bold", size: 22))
                                .bold()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 20) {
                            VStack {
                                Text("\(taskViewModel.getNumCompletedTasksForUser(housemate.id!))")
                                    .font(.system(size: 32))
                                    .foregroundColor(deepPurple)
                                    .bold()
                                Text("Completed")
                                    .font(.custom("Lato", size: 15))
                                    .frame(minWidth: 50)
                                
                            }
                            .padding(30)
                            .padding(.leading, 30)
                            .frame(maxWidth: .infinity, minHeight: 25)
                            
                            VStack {
                                Text("\(taskViewModel.getNumPendingTasksForUser(housemate.id!))")
                                    .foregroundColor(deepPurple)
                                    .font(.system(size: 32))
                                    .bold()
                                Text("Pending")
                                    .font(.custom("Lato", size: 15))
                                    .frame(minWidth: 50)
                                
                            }
                            .padding(30)
                            .padding(.trailing, 30)
                            .frame(maxWidth: .infinity, minHeight: 25)
                            
                            
                        }
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                        )
                        
                    }
                    
                    VStack(spacing: 10) {
                        HStack() {
                            Text("Recent Activity")
                                .font(.custom("Lato-Bold", size: 22))
                                .bold()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if (!recentTasks.isEmpty) {
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                
                                HStack {
                                    
                                    
                                    ForEach(recentTasks) {task in
                                        taskCard(task: task, user: housemate)
                                            .padding(.horizontal)
                                        
                                    }
                                }
                            }
                        } else {
                            Text("There's no recent activity...")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.custom("Lato", size: 15))
                        }
                        
                        Spacer()
                    }
                }.padding(.horizontal, 20)
            }
            .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: backButton())
            
        }
    }
    private func backButton() -> some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .font(.system(size:18))
                    .bold()
                    .padding(.vertical)
            }
        }
    }

}

private func statCardFront(mainText: String, subText: String) -> some View {
    VStack {        
        Text("\(mainText)")
            .font(.system(size: 40))
            .bold()
            .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
        Text("\(subText)")
            .foregroundColor(.black.opacity(0.5))
    }
}

private func statCardBack(mainText: String, subText: String, iconStr: String) -> some View {
    VStack {
        HStack {
            Image(iconStr)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 35, height: 45)
            Text("\(mainText)")
                .bold()
                .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
        }
        Text("\(subText)")
            .foregroundColor(.black.opacity(0.5))
    }
}

struct HousemateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        HousemateProfileView(housemate: UserViewModel.mockUser())
            .environmentObject(AuthViewModel())
            .environmentObject(TaskViewModel())
           
    }
    
}
