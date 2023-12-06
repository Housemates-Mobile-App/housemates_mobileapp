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
    
    var body: some View {
        ZStack {
            if showPreview, let capturedImage = image {
                // When a photo is taken, show the preview
                AfterImagePreviewView(image: capturedImage, isPresented: $isPresented, showPreview: $showPreview)
            } else {
                // This is the camera UI
//                CustomCameraInterfaceView(image: $image, showPreview: $showPreview, takePhoto: takePhoto, onClaimTask: onClaimTask)
                AfterCustomCameraInterfaceView(image: $image, showPreview: $showPreview, takePhoto: takePhoto, onDismiss: {
                    isPresented = false // Dismiss the camera view
                })
            }
        }
    }
}

// MARK: - Image Preview View
struct AfterImagePreviewView: View {
    let image: UIImage
    @Binding var isPresented: Bool
    @Binding var showPreview: Bool

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .edgesIgnoringSafeArea(.all)
            
            HStack {
                Button("Retake") {
                    // Resets the preview state to retake photo
                    self.showPreview = false
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Capsule())
                
                Button("Use Photo") {
                    // Sets the main view to the captured image and dismisses the camera
                    self.isPresented = false
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
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
            // Camera preview
            CustomCameraViewRepresentable(image: $image, isPresented: $showPreview, takePhoto: $takePhoto)

            // Overlay content
            VStack {
                // "Before" label and "Back" button at the top
                HStack {
                    Text("After")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.leading)
                        .shadow(radius: 10)

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
                .background(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.7), .clear]), startPoint: .top, endPoint: .bottom))

                Spacer()

                // "Take a picture now" prompt
                Text("Show us your hard work!")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.75))
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding(.bottom, 25)

                Button(action: {
                    self.takePhoto = true
                }) {
                    CaptureButton()
                }


            }
        }
        .edgesIgnoringSafeArea(.all) // Make sure it covers the whole screen
    }

    struct CaptureButton: View {
        var body: some View {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 75, height: 75)
                Circle()
                    .stroke(Color.white, lineWidth: 5)
                    .frame(width: 85, height: 85)
            }
        }
    }
    
    struct SkipButton: View {
        var body: some View {
            Text("Skip")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .background(Color.black.opacity(0.5))
                .clipShape(Capsule())
        }
    }
}


