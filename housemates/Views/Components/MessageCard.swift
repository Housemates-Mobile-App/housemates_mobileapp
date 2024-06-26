//
//  MessageCard.swift
//  housemates
//
//  Created by Sean Pham on 11/9/23.
//

import SwiftUI

struct MessageCardView: View {
    let message: String
    var body: some View {
        HStack {
            Spacer()
            Text(message)
//                .font(.subheadline)
                .font(.custom("Lato", size: 13))
                .foregroundColor(.gray)
          
            Spacer()
        }
        .padding(EdgeInsets(top: 30, leading: 0, bottom: 30, trailing: 0))
     
        .cornerRadius(12)
        
    }
}

struct MessageCardView_Previews: PreviewProvider {
    static var previews: some View {
        MessageCardView(message: "Error")
    }
}
