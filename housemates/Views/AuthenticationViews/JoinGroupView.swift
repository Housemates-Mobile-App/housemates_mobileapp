//
//  JoinGroupView.swift
//  housemates
//  good source for detecting backspace on empty field: https://swiftuirecipes.com/blog/detect-backspace-in-swiftui
//  Created by Sean Pham on 11/3/23.
//

import SwiftUI

struct JoinGroupView: View {
    @State private var group_code: [String] = Array(repeating: "", count: 4)
    @FocusState private var focusedField: Int?
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var userViewModel : UserViewModel


    let numOfFields = 4
    
    var body: some View {
        VStack {
            // MARK: Housemates Title
            Text("Enter Group Code")
                .padding(.bottom, 20)
                .font(.custom("Nunito-Bold", size: 25))
            
            // MARK: Create a Group Form
                HStack(spacing: 10) {
                    ForEach(0..<numOfFields, id: \.self) { index in
                        TextField("",
                          text: $group_code[index],
                          prompt: Text("0"))
                            .keyboardType(.numberPad)
                            .font(Font.system(size: 60))
                            .multilineTextAlignment(.center)
                            .padding(.all, 10)
                            .focused($focusedField, equals: index)
                            .onChange(of: group_code[index]) { newValue in
                                if newValue.count >= 1 {
                                    if newValue.count > 1 {
                                        group_code[index] = String(newValue.prefix(1))
                                    }
                                    moveFocusToNextField(currentIndex: index)
                                }
                                else if newValue.count == 0 {
                                    moveFocusToPrevField(currentIndex: index)
                                }
                                else if newValue.isEmpty {
                                        moveFocusToPrevField(currentIndex: index)
                                    }
                            }
                            .frame(width: 74, height: 105)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(
                                group_code[index].isEmpty ? Color.black : Color(red: 0.439, green: 0.298, blue: 1.0),
                                lineWidth: 1
                            ))
                    }
                }
                .onChange(of: focusedField) { newFocusedField in
                    if let field = newFocusedField, group_code[field].isEmpty {
                        focusedField = field
                    }
                }
            
            VStack {
                // MARK: Button for Joining Existing Group
                Button {
                    Task {
                        if let uid = authViewModel.currentUser?.id {
                            await userViewModel.joinGroup(group_code: group_code.joined(), uid: uid)
                            await authViewModel.fetchUser()
                        }
                    }
                } label: {
                    HStack {
                        Text("JOIN GROUP")
                            .font(.custom("Nunito-Bold", size: 25))
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                }
                .disabled(!areAllCodesFilled())
                    .opacity(areAllCodesFilled() ? 1.0 : 0.5)
                .padding(.vertical)
                .background(Color(red: 0.439, green: 0.298, blue: 1.0))
                .cornerRadius(10)
                
                Text("Don't know where to find it? Look for 'Group Code' on your housemate's profile page")
                    .font(.custom("Lato", size: 16))
                    .foregroundColor(Color(red: 0.588, green: 0.588, blue: 0.588))
            }.padding(.top, 30)
            Spacer()
        }.padding(.horizontal, 30)
        .padding(.top, 12)
    }
    
    func areAllCodesFilled() -> Bool {
        return group_code.allSatisfy { !$0.isEmpty }
    }
    
    func moveFocusToNextField(currentIndex: Int) {
        if currentIndex < numOfFields - 1 {
            focusedField = currentIndex + 1
        }
    }
    
    func moveFocusToPrevField(currentIndex: Int) {
        if currentIndex > 0 {
            focusedField = currentIndex - 1
        }
    }
}

//#Preview {
//    JoinGroupView()
//}
