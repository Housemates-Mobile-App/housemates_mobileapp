//
//  JoinCreateGroupView.swift
//  housemates
//
//  Created by Sean Pham on 11/3/23.
//

import SwiftUI

struct JoinCreateGroupView: View {
    var body: some View {
           NavigationView {
               HStack(spacing:20) {
                   NavigationLink(destination: JoinGroupView()) {
//                       Text("Join Group")
//                           .padding()
//                           .background(Color.blue)
//                           .foregroundColor(Color.white)
//                           .cornerRadius(10)
                       JoinCreateCard(image: "joinGroupIcon", title: "Join A Group", description: "If you have an existing code for a group")
                   }

                   NavigationLink(destination: CreateGroupView()) {
//                       Text("Create Group")
//                           .padding()
//                           .background(Color.green)
//                           .foregroundColor(Color.white)
//                           .cornerRadius(10)
                       JoinCreateCard(image: "createGroupIcon", title: "Create A Group", description: "If you and your housemates dont have a group")
                   }
               }.padding()
           }
       }
    
}

#Preview {
    JoinCreateGroupView()
}
