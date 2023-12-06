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
    
    var body: some View {
        ZStack {
            if showPreview {
                // When a photo is taken, show the preview
                AfterImagePreviewView(image: $image, isPresented: $isPresented, showPreview: $showPreview, onDismiss: onDismiss)
            } else {
                // This is the camera UI
//                CustomCameraInterfaceView(image: $image, showPreview: $showPreview, takePhoto: takePhoto, onClaimTask: onClaimTask)
                AfterCustomCameraInterfaceView(image: $image, showPreview: $showPreview, takePhoto: takePhoto, onDismiss: {
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
        ZStack { // Use ZStack to ensure the background covers everything
            Color.black.edgesIgnoringSafeArea(.all) // Set the entire background to black

            VStack {
                if let uiImage = image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .edgesIgnoringSafeArea(.all)
                }
                
                HStack(spacing: 20) { // Added spacing between buttons
                    Button("Retake") {
                        self.showPreview = false
                        self.image = nil
                    }
                    .font(.custom("Nunito-Bold", size: 17))
                    .frame(width: 100, height: 30) // Set buttons to same width
                    .padding()
                    .background(Color.white) // White background fill
                    .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0)) // Purple font color
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                        .stroke(Color(red: 0.439, green: 0.298, blue: 1.0), lineWidth: 5) // Purple outline
                    )
                    
                    Button("Use Photo") {
                        self.isPresented = false
                        onDismiss()
                    }
                    .font(.custom("Nunito-Bold", size: 17))
                    .frame(width: 100, height: 30) // Set buttons to same width
                    .padding()
                    .background(Color.white) // White background fill
                    .foregroundColor(Color(red: 0.439, green: 0.298, blue: 1.0)) // Purple font color
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                        .stroke(Color(red: 0.439, green: 0.298, blue: 1.0), lineWidth: 5) // Purple outline
                    )
                }
                .padding() // Add padding if necessary
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
    var onDismiss: () -> Void

    var body: some View {
            ZStack {
                CustomCameraViewRepresentable(image: $image, isPresented: $showPreview, takePhoto: $takePhoto)

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
                    Button(action: {
                        self.takePhoto = true
                    }) {
                        CaptureButton()
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
    struct CaptureButton: View {
        var body: some View {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 75, height: 75)
                Circle()
                    .stroke(Color.purple, lineWidth: 5)
                    .frame(width: 85, height: 85)
            }
        }
    }
}


