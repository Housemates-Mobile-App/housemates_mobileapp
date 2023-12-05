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
    @EnvironmentObject var tabBarViewModel : TabBarViewModel

    let housemate: User
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
    var body: some View {
        ZStack {
            //wave
            VStack {
                NewWave()
                    .fill(deepPurple)
                    .frame(height: 150)
                Spacer()
            }.edgesIgnoringSafeArea(.top)
            
            VStack(spacing: 10) {
                VStack(alignment: .center) {
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
                                    gradient: Gradient(colors: [Color.gray.opacity(0.8), Color.gray.opacity(0.4)]),
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
                }.padding(.bottom, 20)
                
                HStack {
                    VStack {
                        Text("\(taskViewModel.getNumCompletedTasksForUser(housemate.id!))")
                            .font(.system(size: 32))
                            .foregroundColor(deepPurple)
                            .bold()
                        Text("Completed")
                            .font(.system(size: 12))
                    }
                    .padding(.horizontal)
                    .frame(minWidth: 75, minHeight: 25)
                    
                    VStack {
                        Text("\(taskViewModel.getNumPendingTasksForUser(housemate.id!))")
                            .foregroundColor(deepPurple)
                            .font(.system(size: 32))
                            .bold()
                        Text("Pending")
                            .font(.system(size: 12))
                    }
                    .padding(.horizontal)
                    .frame(minWidth: 75, minHeight: 25)
                    
                    
                }.padding(25)
                    .background(
                      RoundedRectangle(cornerRadius: 16)
                          .stroke(Color.gray, lineWidth: 2)
                    )

                
                HStack() {
                    Text("Recent Activity")
                        .font(.custom("Lato-Bold", size: 22))
                        .bold()
                }.padding(.top, 10)
                
                Spacer()
                
            }.padding(.top, 20)
//            .padding(15)
            .border(.red)
        }.onAppear {
            tabBarViewModel.hideTabBar = true
        }.onDisappear {
            withAnimation(.easeIn(duration: 0.2), {
                tabBarViewModel.hideTabBar = false
            })
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
