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
               VStack {
                   NavigationLink(destination: JoinGroupView()) {
                       Text("Join Group")
                           .padding()
                           .background(Color.blue)
                           .foregroundColor(Color.white)
                           .cornerRadius(10)
                   }
                   .padding()

                   NavigationLink(destination: CreateGroupView()) {
                       Text("Create Group")
                           .padding()
                           .background(Color.green)
                           .foregroundColor(Color.white)
                           .cornerRadius(10)
                   }
                   .padding()
               }
           }
       }
    
}

#Preview {
    JoinCreateGroupView()
}
