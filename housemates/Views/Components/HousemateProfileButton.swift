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
        
    var body: some View {
        VStack {
            Button(action: {
                if let url = URL(string: "\(urlScheme)://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 58, height: 51)
                    .shadow(color: Color(red: 0.439, green: 0.298, blue: 1.0).opacity(0.25), radius: 2, x: 0, y: 2)
                    .overlay(
                        VStack(spacing: 5) {
                            Image(iconStr)
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text(title)
                                .foregroundColor(.black)
                                .font(.system(size: 12))
                                .bold()
                        }
                    )
            }
        }
    }
}

#Preview {
    HousemateProfileButton(phoneNumber: "1234567890", title: "Call", iconStr: "phone", urlScheme:"tel")
}
