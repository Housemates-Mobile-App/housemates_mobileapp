//
//  CustomCameraView.swift
//  housemates
//
//  Created by Sanmoy Karmakar on 12/5/23.
//

import SwiftUI
import AVFoundation
import UIKit


// MARK: - Custom Camera View in SwiftUI
struct BeforeCameraView: View {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool
    @State private var takePhoto = false
    @State private var showPreview = false
    var onClaimTask: (UIImage?) -> Void
    
    var body: some View {
        ZStack {
            if showPreview, let capturedImage = image {
                // When a photo is taken, show the preview
                BeforeImagePreviewView(image: capturedImage, isPresented: $isPresented, showPreview: $showPreview, onClaimTask: onClaimTask)
            } else {
                // This is the camera UI
//                CustomCameraInterfaceView(image: $image, showPreview: $showPreview, takePhoto: takePhoto, onClaimTask: onClaimTask)
                BeforeCustomCameraInterfaceView(image: $image, showPreview: $showPreview, takePhoto: takePhoto, onClaimTask: onClaimTask, onDismiss: {
                    isPresented = false // Dismiss the camera view
                })
            }
        }
    }
}

//// MARK: - Custom Camera View in SwiftUI
//struct CustomCameraView: View {
//    @Binding var image: UIImage?
//    @Binding var isPresented: Bool
//    @State private var takePhoto = false
//
//    var body: some View {
//        ZStack {
//            CustomCameraViewRepresentable(image: $image, isPresented: $isPresented, takePhoto: $takePhoto)
//                .edgesIgnoringSafeArea(.all)
//
//            VStack {
//                Spacer()
//
//                VStack {
//                    Text("Take a picture now, you'll see your hard work after!")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.black.opacity(0.75))
//                        .cornerRadius(10)
//                        .padding(.bottom, 25)
//
//                    Button(action: {
//                        self.takePhoto = true
//                    }) {
//                        ZStack {
//                            Circle()
//                                .fill(Color.white)
//                                .frame(width: 75, height: 75)
//                            Circle()
//                                .stroke(Color.white, lineWidth: 5)
//                                .frame(width: 85, height: 85)
//                        }
//                    }
//                    .padding(.bottom, 30)
//
//                    Button(action: {
//                        isPresented = false
//                    }) {
//                        Text("Skip")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .padding(.horizontal, 30)
//                            .padding(.vertical, 10)
//                            .background(Color.black.opacity(0.5))
//                            .clipShape(Capsule())
//                    }
//                }
//            }
//        }
//    }
//}

// MARK: RETAKE Functionality
// XXXXXXXXXXXXXXXXXXXXXXXX
// XXXXXXXXXXXXXXXXXXXXXXXX
// XXXXXXXXXXXXXXXXXXXXXXXX
// XXXXXXXXXXXXXXXXXXXXXXXX

// MARK: - Image Preview View
struct BeforeImagePreviewView: View {
    let image: UIImage
    @Binding var isPresented: Bool
    @Binding var showPreview: Bool
    let onClaimTask: (UIImage?) -> Void
    
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
                    onClaimTask(image)
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


//// MARK: - Custom Camera Interface View
//struct BeforeCustomCameraInterfaceView: View {
//    @Binding var image: UIImage?
//    @Binding var showPreview: Bool
//    @State var takePhoto: Bool
//    var onClaimTask: (UIImage?) -> Void
//    var onDismiss: () -> Void
//    
//    var body: some View {
//        ZStack {
//            CustomCameraViewRepresentable(image: $image, isPresented: $showPreview, takePhoto: $takePhoto)
//            
//            VStack {
//                Spacer()
//                
//                VStack {
//                    HStack {
//                        Button("Back") {
//                            onDismiss() // Call the dismiss closure
//                        }
//                        .padding()
//                        .background(Color.gray)
//                        .foregroundColor(.white)
//                        .clipShape(Capsule())
//
//                        Spacer()
//                    }
//                    .padding()
//
//                    Spacer()
//                    
//                    VStack {
//                        Text("Take a picture now, you'll see your hard work after!")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .padding()
//                            .background(Color.black.opacity(0.75))
//                            .cornerRadius(10)
//                            .padding(.bottom, 25)
//                        
//                        Button(action: {
//                            self.takePhoto = true
//    //                        self.showPreview = true
//    //                        cameraController.captureImage()
//                        }) {
//                            CaptureButton()
//                        }
//                        .padding(.bottom, 30)
//                        
//                        //                Button(action: {
//                        //                    self.cameraController.takePicture { newImage in
//                        //                        self.image = newImage
//                        //                        self.showPreview = true // Show the preview when a photo is taken
//                        //                    }
//                        //                }) {
//                        //                }
//                        
//                        Button(action: {
//                            onClaimTask(nil)
//                            self.showPreview = false
//                        }) {
//                            SkipButton()
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    // These are the UI components for the capture and skip buttons
//    struct CaptureButton: View {
//        var body: some View {
//            ZStack {
//                Circle()
//                    .fill(Color.white)
//                    .frame(width: 75, height: 75)
//                Circle()
//                    .stroke(Color.white, lineWidth: 5)
//                    .frame(width: 85, height: 85)
//            }
//        }
//    }
//    
//    struct SkipButton: View {
//        var body: some View {
//            Text("Skip")
//                .font(.headline)
//                .foregroundColor(.white)
//                .padding(.horizontal, 30)
//                .padding(.vertical, 10)
//                .background(Color.black.opacity(0.5))
//                .clipShape(Capsule())
//        }
//    }
//}

// MARK: - Custom Camera Interface View
struct BeforeCustomCameraInterfaceView: View {
    @Binding var image: UIImage?
    @Binding var showPreview: Bool
    @State var takePhoto: Bool
    var onClaimTask: (UIImage?) -> Void
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            // Camera preview
            CustomCameraViewRepresentable(image: $image, isPresented: $showPreview, takePhoto: $takePhoto)

            // Overlay content
            VStack {
                // "Before" label and "Back" button at the top
                HStack {
                    Text("Before")
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
                Text("Take a picture now, you'll see your hard work after!")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.75))
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding(.bottom, 25)

                // Capture button
                Button(action: {
                    self.takePhoto = true
                }) {
                    CaptureButton()
                }

                // Skip button
                Button(action: {
                    onClaimTask(nil)
                    self.showPreview = false
                }) {
                    SkipButton()
                }
                .padding(.bottom, SafeAreaInsets.bottom + 20)
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

