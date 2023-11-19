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
               VStack(spacing:30) {
                   NavigationLink(destination: JoinGroupView()) {
                       JoinCreateCard(image1:"joinGroupIconNew2", title: "Join A Group", description: "Have an existing code? Tap here!")
                   }

                   NavigationLink(destination: CreateGroupView()) {
                       JoinCreateCard(image1:"createGroupIconNew2", title: "Create A Group", description: "Starting from scratch? Tap here!")
                   }
               }.padding()
           }
       }
    
}

#Preview {
    JoinCreateGroupView()
}
