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
                       JoinCreateCard(image: "JoinGroupIcon", title: "Join A Group", description: "If you have an existing code for a group")
                   }

                   NavigationLink(destination: CreateGroupView()) {
                       JoinCreateCard(image: "createGroupIcon", title: "Create A Group", description: "If you and your housemates don't have a group")
                   }
               }.padding()
           }
       }
    
}

//#Preview {
//    JoinCreateGroupView()
//}
