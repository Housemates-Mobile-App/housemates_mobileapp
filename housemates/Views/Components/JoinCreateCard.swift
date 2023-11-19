//
//  JoinCreateCard.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/7/23.
//

import SwiftUI

struct JoinCreateCard: View {
    var image1: String
    var title: String
    var description: String
    
    var body: some View {

        VStack {
            Image(image1)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width:120, height:75)
            
            Text(title)
                .font(.custom("Nunito-Bold", size: 25))
                .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                .padding(.bottom, 8)
            
            Text(description)
                .font(.custom("Nunito", size: 17))
                .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
        }
        .padding(25)
        .background(.white)
        .cornerRadius(20)
        .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.gray.opacity(0.6), lineWidth: 3)
            )

    }
}

#Preview {
    JoinCreateCard(image1:"joinGroupIconNew2", title:"JOIN A GROUP", description:"Have an existing code? Click here!")
}
