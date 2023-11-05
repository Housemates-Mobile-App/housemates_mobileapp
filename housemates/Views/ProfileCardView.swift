//
//  ProfileCardView.swift
//  housemates
//
//  Created by Bernard Sheng on 11/5/23.
//

import SwiftUI

struct ProfileCardView: View {
    var body: some View {
      VStack {
//        profile picture
        Image("danielFace")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 75, height: 75)
          .clipShape(Circle())
          .overlay(Circle().stroke(Color.white, lineWidth: 2))
          .shadow(radius: 5)
          .padding(.bottom, 15)
        
        Text("Daniel")
        Text("Not Home")
          .font(.system(size: 10))
          .foregroundColor(.gray)
        
        
      }
      .padding(.vertical, 25)
      .padding(.horizontal, 25)
      
      .background(
        RoundedRectangle(cornerRadius: 25)
          .stroke(.black, lineWidth: 1)
      )
      
      
      
      
      
        
    }
}

struct ProfileCardView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCardView()
    }
}
