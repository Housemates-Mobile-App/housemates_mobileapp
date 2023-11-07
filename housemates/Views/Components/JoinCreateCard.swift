//
//  JoinCreateCard.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/7/23.
//

import SwiftUI

struct JoinCreateCard: View {
    var image: String
    var title: String
    var description: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(radius: 4)
//                .frame(width: 300, height: 200)
            
            VStack(alignment: .leading, spacing: 8) {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxHeight: 150)
                    .cornerRadius(15)
                    .clipped()
                
                Text(title)
                    .font(.system(size:30))
                    .foregroundColor(.black)
                
                Text(description)
                    .font(.system(size:15))
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
}

#Preview {
    JoinCreateCard(image:"joinGroupIcon", title:"title", description:"description")
}
