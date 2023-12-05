//
//  CustomCameraView.swift
//  housemates
//
//  Created by Sanmoy Karmakar on 12/5/23.
//

import SwiftUI
import AVFoundation

// MARK: - Custom Camera View in SwiftUI
struct CustomCameraView: View {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool
    @State private var takePhoto = false
    
    var body: some View {
        ZStack {
            CustomCameraViewRepresentable(image: $image, isPresented: $isPresented, takePhoto: $takePhoto)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                VStack {
                    Text("Take a picture now, you'll see your hard work after!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.75))
                        .cornerRadius(10)
                        .padding(.bottom, 25)
                    
                    Button(action: {
                        self.takePhoto = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 75, height: 75)
                            Circle()
                                .stroke(Color.white, lineWidth: 5)
                                .frame(width: 85, height: 85)
                        }
                    }
                    .padding(.bottom, 30)
                    
                    Button(action: {
                        isPresented = false
                    }) {
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
        }
    }
}


// MARK: - Custom Camera View Controller
class CustomCameraViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var photoOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var takePhoto: ((UIImage?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    func setupCaptureSession() {
        captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        
        // Add video input.
        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession.canAddInput(videoDeviceInput) else { return }
        
        captureSession.addInput(videoDeviceInput)
        
        // Add photo output.
        photoOutput = AVCapturePhotoOutput()
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        
        captureSession.commitConfiguration()
        
        // Add preview layer.
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func captureImage() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CustomCameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            takePhoto?(nil)
            return
        }
        takePhoto?(image)
    }
}

// MARK: - UIViewControllerRepresentable for Custom Camera
struct CustomCameraViewRepresentable: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool
    @Binding var takePhoto: Bool  // A binding to control when to take a photo

    func makeUIViewController(context: Context) -> CustomCameraViewController {
        let controller = CustomCameraViewController()
        controller.takePhoto = { image in
            DispatchQueue.main.async {
                self.image = image
                self.isPresented = false
            }
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CustomCameraViewController, context: Context) {
        if takePhoto {
            uiViewController.captureImage()
            DispatchQueue.main.async {
                self.takePhoto = false  // Reset the state after taking the photo
            }
        }
    }
}
