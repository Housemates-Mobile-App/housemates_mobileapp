//
//  AllHousematesView.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/9/23.
//
import SwiftUI
import CachedAsyncImage

struct AllHousematesView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var userViewModel : UserViewModel
    @EnvironmentObject var groupViewModel : GroupViewModel

    var body: some View {
        if let user = authViewModel.currentUser {
            // Top part with a different background color
            let userGroupmatesInclusive = userViewModel.getUserGroupmatesInclusive(user.id!)
            let userWithNextBirthday = userViewModel.userWithNextBirthday(users: userGroupmatesInclusive)
            VStack(spacing:20) {
                VStack  {
                    HStack {
                        if let currGroup = groupViewModel.getGroupByID(user.group_id ?? "") {
                            Text("Residents of \(currGroup.name)")
                                .font(.system(size: 25))
                                .bold()
                                .foregroundColor(.white)
                                .padding(.top, 45)
                                .padding(.leading, 10)
                        } else {
                            Text("Residents of this House")
                                .font(.system(size: 25))
                                .bold()
                                .foregroundColor(.white)
                                .padding(.top, 45)
                                .padding(.leading, 10)
                        }
                        Spacer()
                    }
                }
                .frame(width: 400, height: 120)
                .background(Color(red: 0.439, green: 0.298, blue: 1.0))
                
                ForEach(userGroupmatesInclusive) { mate in
                    AllHousematesCard(housemate: mate)
                }
                HStack {
                    Text("Nice To Know")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                        .bold()
                    Spacer()
                }.padding(5)
                    .background(
                    RoundedRectangle(cornerRadius: 15)
                      .fill(Color(red: 0.439, green: 0.298, blue: 1.0))
                )
                VStack {
                    let imageURL = URL(string: userWithNextBirthday?.imageURLString ?? "")
                    
                    CachedAsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .frame(width: 67, height: 67)
                        
                    } placeholder: {
            
                        // MARK: Default user profile picture
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .frame(width: 67, height: 67)
                    }
                    Text("Next Birthday")
                        .font(.system(size:15))
                        .opacity(0.40)
                    if let birthday = userWithNextBirthday?.birthday {
                        
                        let startIndexDay = birthday.index(birthday.startIndex, offsetBy: 0)
                        let endIndexDay = birthday.index(startIndexDay, offsetBy: 2)
                        let daySubstring = birthday[startIndexDay..<endIndexDay]
                        let day = String(daySubstring)

                        let startIndexMonth = birthday.index(startIndexDay, offsetBy: 3)
                        let endIndexMonth = birthday.index(startIndexMonth, offsetBy: 2)
                        let monthSubstring = birthday[startIndexMonth..<endIndexMonth]
                        let month = String(monthSubstring)

                        let formattedBirthday = "\(month).\(day)"
                        
                        Text(formattedBirthday)
                            .font(.system(size:40))
                            .bold()
                            .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                    } else {
                        Text("None")
                            .font(.system(size:40))
                            .bold()
                            .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                    }
                    
                }.frame(width: 128, height: 168)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 10
                        ).fill(.white.opacity(0.9))
                    )
                Spacer()
            }.background(
                LinearGradient(gradient: Gradient(colors: [
                    Color(red: 0.925, green: 0.863, blue: 1.0).opacity(1.00),
                    Color(red: 0.619, green: 0.325, blue: 1.0).opacity(0.51)
                ]), startPoint: .top, endPoint: .bottom)
            ).ignoresSafeArea(.all)
        }
    }
}

struct AllHousematesView_Previews: PreviewProvider {
    static var previews: some View {
    
        AllHousematesView()
            .environmentObject(AuthViewModel.mock())
            .environmentObject(UserViewModel())
            .environmentObject(GroupViewModel())
           
    }
    
}
