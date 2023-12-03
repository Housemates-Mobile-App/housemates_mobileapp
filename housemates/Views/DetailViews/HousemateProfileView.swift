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
    let housemate: User
    var body: some View {
        VStack(spacing: 10) {
            VStack(alignment: .center) {
                //image
                let imageURL = URL(string: housemate.imageURLString ?? "")
                
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 111, height: 111)
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
                    HousemateProfileButton(phoneNumber: housemate.phone_number, title: "Call", iconStr: "phone", urlScheme:"tel")
                    HousemateProfileButton(phoneNumber: housemate.phone_number, title: "Text", iconStr: "message", urlScheme:"sms")
                }
            }
            
            VStack (alignment: .leading) {
                HStack {
                    Image("entrance")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 29, height: 32)
                    Text("Joined June 15")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0x7E / 255.0, green: 0x7E / 255.0, blue: 0x7E / 255.0))
                    Spacer()
                }
                HStack {
                    Image("birthday")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 29, height: 32)
                    Text("Birthday on Oct 5")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0x7E / 255.0, green: 0x7E / 255.0, blue: 0x7E / 255.0))
                }
            }.padding(.top, 20)
            
            Divider()
            
            HStack() {
                Text("Tasks This Week")
                    .font(.system(size:22))
                    .bold()
                Spacer()
            }.padding(.top, 10)
            VStack(alignment: .leading) {
                
                //chart
                Chart {
                    ForEach(hardcodedTaskDataPoints) { dataPoint in
                        LineMark (
                            x: .value("day", dataPoint.day),
                            y: .value("total tasks", dataPoint.totalTasks)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(Color(red: 0.439, green: 0.298, blue: 1.0))
                        .symbol() {
                            Circle()
                                .fill(Color(red: 0.439, green: 0.298, blue: 1.0))
                                .frame(width:15)
                        }
                    }
                }.chartYAxis() {
                    AxisMarks(position: .leading)
                }
                
            }.padding(15)
                .frame(width: 350, height: 200)
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(.black.opacity(0.3), lineWidth: 2))
            
            HStack() {
                Text("Stats")
                    .font(.system(size:22))
                    .bold()
                Spacer()
            }.padding(.top, 10)
            
            HStack(spacing: 20) {

                // card 1
                FlashcardComponent(front: statCardFront(mainText:"\(taskViewModel.getCompletedTasksForUser(housemate.id!).count)", subText:"completed"), back: statCardBack(mainText:"Clean Dish", subText:"recently done", iconStr:"dalle1"))
                
                // card 2
                FlashcardComponent(front: statCardFront(mainText:"\(taskViewModel.getPendingTasksForUser(housemate.id!).count)", subText:"pending"), back: statCardBack(mainText:"Wash Counter", subText:"most urgent", iconStr:"dalle2"))

            }
        }.padding(15)
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
