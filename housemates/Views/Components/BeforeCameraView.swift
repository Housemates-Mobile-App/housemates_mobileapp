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
//    var onClaimTask: (UIImage?) -> Void
    
    var body: some View {
        ZStack {
            if showPreview {
                // When a photo is taken, show the preview
                BeforeImagePreviewView(image: $image, isPresented: $isPresented, showPreview: $showPreview)//, onClaimTask: onClaimTask)
            } else {
                // This is the camera UI
//                CustomCameraInterfaceView(image: $image, showPreview: $showPreview, takePhoto: takePhoto, onClaimTask: onClaimTask)
                BeforeCustomCameraInterfaceView(image: $image, showPreview: $showPreview, takePhoto: takePhoto, onDismiss: {
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
    @Binding var image: UIImage?
    @Binding var isPresented: Bool
    @Binding var showPreview: Bool
//    let onClaimTask: (UIImage?) -> Void
    
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
//    var onClaimTask: (UIImage?) -> Void
    var onDismiss: () -> Void

    var body: some View {
            ZStack {
                CustomCameraViewRepresentable(image: $image, isPresented: $showPreview, takePhoto: $takePhoto)

                VStack {
                    // "Before" label and "Take a picture now" prompt at the top, centered
                    VStack (spacing: -10) {
                        Text("Take a picture now, you'll see your hard work after!")
                            .font(.custom("Nunito-Bold", size: 17))
                            .foregroundColor(.white)
                            .padding([.leading, .trailing], 10)
                            .padding([.top, .bottom], 10)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                        Text("Before")
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
                    
                    //SKip Button
                    //                Button(action: {
                    ////                    onClaimTask(nil)
                    //                    self.showPreview = false
                    //                }) {
                    //                    SkipButton()
                    //                }
                    //                .padding(.bottom, SafeAreaInsets.bottom + 20)
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
                    .stroke(Color(red: 0.439, green: 0.298, blue: 1.0), lineWidth: 5)
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

