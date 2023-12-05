//
//  HousemateProfileButton.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/12/23.
//

import SwiftUI

struct HousemateProfileButton: View {
    var phoneNumber: String
    var title: String
    var iconStr: String
    var urlScheme: String
    let deepPurple = Color(red: 0.439, green: 0.298, blue: 1.0)
        
    var body: some View {
        VStack {
            Button(action: {
                if let url = URL(string: "\(urlScheme)://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(deepPurple)
                    .frame(width: 126, height: 40)
                    .overlay(
                        HStack(spacing: 10) {
                            Image(systemName: iconStr)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                            
                            Text(title)
                                .foregroundColor(.white)
                                .font(.custom("Lato-Bold", size: 13))
                                .bold()
                        }
                    )
            }
        }
    }
}

//#Preview {
//    HousemateProfileButton(phoneNumber: "1234567890", title: "Call", iconStr: "phone.fill", urlScheme:"tel")
//}
