//
//  FeedCardView.swift
//  housemates
//
//  Created by Bernard Sheng on 11/5/23.
//

import SwiftUI

struct FeedCardView: View {
    var body: some View {
      VStack(alignment: .leading) {
        Text("Sanmoy completed this task: Take Out Trash")
          .padding(.bottom, 20)
        HStack(){
          Image(systemName: "heart")
          Image(systemName: "message")
          Spacer()
          Text("2 min ago")
            .foregroundColor(.gray)
        }
       
        
      }
      .padding(25)
//      dynamically set a border
      .frame(maxWidth: UIScreen.main.bounds.width * 0.95)
      .background(
        RoundedRectangle(cornerRadius: 25)
          .stroke(.black, lineWidth: 1)
      )
    }
}

struct FeedCardView_Previews: PreviewProvider {
    static var previews: some View {
        FeedCardView()
    }
}
