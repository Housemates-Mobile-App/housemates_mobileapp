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
                .font(.title)
                .foregroundColor(.black)
            Spacer()
        }
        .padding(EdgeInsets(top: 30, leading: 0, bottom: 30, trailing: 0))
        .background(Color.white)
        .cornerRadius(10)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

struct MessageCardView_Previews: PreviewProvider {
    static var previews: some View {
        MessageCardView(message: "Error")
    }
}
