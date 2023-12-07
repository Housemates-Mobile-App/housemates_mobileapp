//
//  CustomCameraView.swift
//  housemates
//
//  Created by Sanmoy Karmakar on 12/5/23.
//

import SwiftUI
import AVFoundation

// MARK: - Custom Camera View in SwiftUI
struct AfterCameraView: View {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool
    @State private var takePhoto = false
    @State private var showPreview = false
    var onDismiss: () -> Void
    @State private var flipCamera = false
    
    var body: some View {
        ZStack {
            if showPreview {
                // When a photo is taken, show the preview
                AfterImagePreviewView(image: $image, isPresented: $isPresented, showPreview: $showPreview, onDismiss: onDismiss)
            } else {
                // This is the camera UI
//                CustomCameraInterfaceView(image: $image, showPreview: $showPreview, takePhoto: takePhoto, onClaimTask: onClaimTask)
                AfterCustomCameraInterfaceView(image: $image, showPreview: $showPreview, takePhoto: takePhoto, flipCamera: $flipCamera, onDismiss: {
                    isPresented = false
                    onDismiss()// Dismiss the camera view
                })
            }
        }
    }
}

// MARK: - Image Preview View
struct AfterImagePreviewView: View {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool
    @Binding var showPreview: Bool
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {
                if let uiImage = image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .edgesIgnoringSafeArea(.all)
                }
                
                HStack(spacing: 20) {
                    Button("Retake") {
                        self.showPreview = false
                        self.image = nil
                    }
                    .font(.custom("Nunito-Bold", size: 17))
                    .frame(width: 100, height: 30)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                        .stroke(Color(red: 0.439, green: 0.298, blue: 1.0), lineWidth: 5)
                    )
                    
                    Button("Use Photo") {
                        self.isPresented = false
                        onDismiss()
                    }
                    .font(.custom("Nunito-Bold", size: 17))
                    .frame(width: 100, height: 30)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                        .stroke(Color(red: 0.439, green: 0.298, blue: 1.0), lineWidth: 5)
                    )
                }
                .padding()
            }
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct AfterCustomCameraInterfaceView: View {
    @Binding var image: UIImage?
    @Binding var showPreview: Bool
    @State var takePhoto: Bool
    @Binding var flipCamera: Bool

    var onDismiss: () -> Void
    

    var body: some View {
            ZStack {
//                CustomCameraViewRepresentable(image: $image, isPresented: $showPreview, takePhoto: $takePhoto)
                CustomCameraViewRepresentable(image: $image, isPresented: $showPreview, takePhoto: $takePhoto, flipCamera: $flipCamera)

                VStack {
                    VStack (spacing: -10) {
                        Text("Show us your hard work!")
                            .font(.custom("Nunito-Bold", size: 17))
                            .foregroundColor(.white)
                            .padding([.leading, .trailing], 10)
                            .padding([.top, .bottom], 10)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                        Text("After")
                            .font(.custom("Nunito-Bold", size: 26))
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0))
                            .shadow(radius: 10)
                    }
                    .background(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.7), .clear]), startPoint: .top, endPoint: .bottom))
                    .padding(.top, SafeAreaInsets.top + 30)
                    .frame(maxWidth: .infinity, alignment: .center)

                    Spacer()

                    // Capture button
                    CaptureButton()
                    .onTapGesture {
                        self.takePhoto = true
                    }

                    FlipButton()
                    .onTapGesture {
                        flipCamera.toggle()
                    }
                    .padding(.bottom, SafeAreaInsets.bottom + 20)
                    
                }
                .edgesIgnoringSafeArea(.all)

                // "Back" button at the top right
                VStack {
                    HStack {
                        Spacer()

                        Button(action: onDismiss) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(.trailing)
                                .shadow(radius: 10)
                        }
                    }
                    .padding(.top, SafeAreaInsets.top)
                    .padding(.trailing)
                    .background(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.7), .clear]), startPoint: .top, endPoint: .bottom))

                    Spacer()
                }
            }
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
        }
}


