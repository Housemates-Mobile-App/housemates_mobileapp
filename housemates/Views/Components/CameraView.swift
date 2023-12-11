
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
        previewLayer.videoGravity = .resizeAspect
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
    
    func switchCamera() {
        guard AVCaptureDevice.devices(for: .video).count > 1 else {
            print("The device does not have more than one camera.")
            return
        }

        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }

        guard let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput else { return }
        captureSession.removeInput(currentInput)

        let newCameraDirection: AVCaptureDevice.Position = (currentInput.device.position == .back) ? .front : .back

        guard let newCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newCameraDirection),
              let newVideoInput = try? AVCaptureDeviceInput(device: newCameraDevice) else { return }

        if captureSession.canAddInput(newVideoInput) {
            captureSession.addInput(newVideoInput)
        }
    }

}

// MARK: - AVCapturePhotoCaptureDelegate
extension CustomCameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              var image = UIImage(data: imageData) else {
            onPhotoCapture?(nil)
            return
        }
        
        // Check if the current camera is front-facing and flip the image if needed
        if let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput, currentInput.device.position == .front {
            image = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .leftMirrored)
        }
        
        onPhotoCapture?(image)
    }
}

// MARK: - UIViewControllerRepresentable for Custom Camera
struct CustomCameraViewRepresentable: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool
    @Binding var takePhoto: Bool
    @Binding var flipCamera: Bool

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
        
        if flipCamera {
            uiViewController.switchCamera()
            // Reset the state after flipping the camera
            DispatchQueue.main.async {
                self.flipCamera = false
            }
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

struct FlipButton: View {
    var body: some View {
        Image(systemName: "camera.rotate")
            .font(.title)
            .foregroundColor(.white)
            .padding()
            .background(Color.gray.opacity(0.7))
            .clipShape(Circle())
    }
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

func updateZoom(zoomFactor: CGFloat) {
    if let device = AVCaptureDevice.default(for: .video) {
        do {
            try device.lockForConfiguration()
            defer { device.unlockForConfiguration() }
            // Set the desired zoom factor within the device's active format's video zoom factor upscaled binned range
            device.videoZoomFactor = max(1.0, min(device.activeFormat.videoMaxZoomFactor, zoomFactor))
        } catch {
            print("Unable to set zoom factor due to an error: \(error)")
        }
    }
}
