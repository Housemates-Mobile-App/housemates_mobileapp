//
//  HomeScreenView.swift
//  housemates
//
//  Created by Sean Pham on 11/2/23.
//

import SwiftUI

struct AuthContentView: View {
    @State var selected = 0
    @EnvironmentObject var tabBarViewModel : TabBarViewModel
    @EnvironmentObject var taskViewModel: TaskViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            if selected == 0 {
                            HomeView()
                            
                        } else if selected == 1 {
                            TaskBoardView()
                            
                        } else if selected == 2 {
                            DashboardView()

                        } else if selected == 3 {
                            ProfileView()

                        }
                        
            if tabBarViewModel.hideTabBar == false {
                BottomBar(selected : $selected).padding()
                    .padding(.horizontal, 15)
                    .background(CurvedShape().fill(Color.white).shadow(radius: 1))
                
                Button(action: {
                    tabBarViewModel.showTaskSelectionView = true
                }) {
                    Image(systemName: "plus").padding(18)
                        .foregroundColor(.white)
                        .bold()
                }.background(Color(red: 0.439, green: 0.298, blue: 1.0))
                    .clipShape(Circle())
                    .offset(y: -5)
                    .shadow(radius: 1)
            } else if tabBarViewModel.hideTabBar == true {
                EmptyView()
            }
        }.sheet(isPresented: $tabBarViewModel.showTaskSelectionView) {
            TaskSelectionView(user: authViewModel.currentUser!)
        }.onAppear {
            taskViewModel.setupRecurringTaskReset()
        }
    }
        
}

struct CurvedShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            let yOffset: CGFloat = 15 // Shift down by 20 points

            path.move(to: CGPoint(x: 0, y: 0 + yOffset))
            path.addLine(to: CGPoint(x: rect.width, y: 0 + yOffset))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height + 30 + yOffset))
            path.addLine(to: CGPoint(x: 0, y: rect.height + 30 + yOffset))
            
            // MARK: - CURVE CENTER
            
            let mid = rect.width / 2
            
            path.move(to: CGPoint(x: mid - 70, y: 0 + yOffset))
            
            let to1 = CGPoint(x: mid, y: 45 + yOffset)
            let control1 = CGPoint(x: mid - 35, y: 0 + yOffset)
            let control2 = CGPoint(x: mid - 35, y: 45 + yOffset)
            
            path.addCurve(to: to1, control1: control1, control2: control2)
            
            let to2 = CGPoint(x: mid + 70, y: 0 + yOffset)
            let control3 = CGPoint(x: mid + 35, y: 45 + yOffset)
            let control4 = CGPoint(x: mid + 35, y: 0 + yOffset)
            
            path.addCurve(to: to2, control1: control3, control2: control4)
        }
    }
}

struct tabHighlight: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        return Path(path.cgPath)
    }
}

struct BottomBar: View {
    @Binding var selected : Int
    
    var body: some View {
        HStack {
            VStack {
//                tabHighlight()
//                    .fill(Color(red: 0.439, green: 0.298, blue: 1.0).opacity(selected == 0 ? 1 : 0))
//                    .frame(width: 45, height: 6)
//                    .offset(y: 7)
                
                Button(action: {
//                    withAnimation(.easeIn(duration: 0.15), {
                        self.selected = 0
//                    })
                }) {
                    
                    Image(systemName: "house.fill")
                        .font(.system(size: 22))
                        .offset(y: 13)
                    
                }.foregroundColor(self.selected == 0 ? Color(red: 0.439, green: 0.298, blue: 1.0) : .gray)
            }.offset(x: -10)
            
            Spacer(minLength: 12)
            
            VStack {
//                tabHighlight()
//                    .fill(Color(red: 0.439, green: 0.298, blue: 1.0).opacity(selected == 1 ? 1 : 0))
//                    .frame(width: 45, height: 6)
//                    .offset(y: 5)
                Button(action: {
//                    withAnimation(.easeIn(duration: 0.15), {
                        self.selected = 1
//                    })
                }) {
                    Image(systemName: "checkmark.square.fill")
                        .font(.system(size: 23))
                        .offset(y: 15)
                }.foregroundColor(self.selected == 1 ? Color(red: 0.439, green: 0.298, blue: 1.0) : .gray)
            }
            
            Spacer().frame(width: 150)
            
            
            VStack {
//                tabHighlight()
//                    .fill(Color(red: 0.439, green: 0.298, blue: 1.0).opacity(selected == 2 ? 1 : 0))
//                    .frame(width: 45, height: 6)
//                    .offset(y: 6)
                
                Button(action: {
//                    withAnimation(.easeIn(duration: 0.15), {
                        self.selected = 2
//                    })
                }) {
                    Image(systemName: "chart.pie.fill")
                        .font(.system(size: 22))
                        .offset(y: 15)
                }.foregroundColor(self.selected == 2 ? Color(red: 0.439, green: 0.298, blue: 1.0) : .gray)
            }
            Spacer(minLength: 12)
            
            VStack {
//                tabHighlight()
//                    .fill(Color(red: 0.439, green: 0.298, blue: 1.0).opacity(selected == 3 ? 1 : 0))
//                    .frame(width: 45, height: 6)
//                    .offset(y: 4)
                
                Button(action: {
//                    withAnimation(.easeIn(duration: 0.15), {
                        self.selected = 3
//                    })
                }) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 22))
                        .offset(y: 15)
                }.foregroundColor(self.selected == 3 ? Color(red: 0.439, green: 0.298, blue: 1.0) : .gray)
            }.offset(x: 10)
        }
    }
}

#Preview {
    AuthContentView()
}
