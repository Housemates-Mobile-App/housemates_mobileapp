//
//  CameraView.swift
//  housemates
//
//  Created by Sanmoy Karmakar on 11/28/23.
//

import SwiftUI
import AVFoundation

// MARK: - Custom Camera View Controller
class CustomCameraViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var photoOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var onPhotoCapture: ((UIImage?) -> Void)?

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
        guard let photoOutput = self.photoOutput else {
            print("Error: photoOutput is nil")
            return
        }
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CustomCameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            onPhotoCapture?(nil)
            return
        }
        onPhotoCapture?(image)
    }
}

// MARK: - UIViewControllerRepresentable for Custom Camera
struct CustomCameraViewRepresentable: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool
    @Binding var takePhoto: Bool  // A binding to control when to take a photo

    func makeUIViewController(context: Context) -> CustomCameraViewController {
        let controller = CustomCameraViewController()
        controller.onPhotoCapture = { [self] image in
            DispatchQueue.main.async {
                self.image = image
                // Only show the preview if an image was captured
                if image != nil {
                    self.isPresented = true
                }
            }
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CustomCameraViewController, context: Context) {
        if takePhoto {
            uiViewController.captureImage()
//            DispatchQueue.main.async {
//                self.takePhoto = false  // Reset the state after taking the photo
//            }
        }
    }
}

struct SafeAreaInsets {
    static var top: CGFloat {
        UIApplication.shared.windows.first { $0.isKeyWindow }?.safeAreaInsets.top ?? 0
    }
    static var bottom: CGFloat {
        UIApplication.shared.windows.first { $0.isKeyWindow }?.safeAreaInsets.bottom ?? 0
    }
}
