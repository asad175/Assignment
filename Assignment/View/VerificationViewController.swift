//
//  SplitViewController.swift
//  Assignment
//
//  Created by Asad Choudhary on 1/28/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

import UIKit
import AVFoundation

class VerificationViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var viewPreview: UIView!
    @IBOutlet weak var viewScanArea: UIView!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var metadataOutput: AVCaptureMetadataOutput!
    
    var viewModel : VerificationViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializations()
        initializeScannerView()
    }
    
    func initializations() {
        self.navigationItem.title = "QR Code Scanner"
        viewScanArea.layer.borderColor = UIColor.green.cgColor
        viewScanArea.layer.borderWidth = 5.0
    }
    
    func initializeScannerView() {
        
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
           
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewPreview.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewPreview.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()

    }
    
    // If Camera Permission is cancelled, Or device doesn't support it
    func failed() {
        Utils.showSimpleAlert(controller: self, title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", buttonText: "OK")
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
        
        configureVideoOrientation()
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning() // Stop capture session, when View Controller is not in foreground
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Handle QR Code Scan Result
        if let metadataObject = metadataObjects.first {
            showRectOnQRCode(metadataObject: metadataObject)
            captureSession.stopRunning()
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
    // Moving Rectangle on the found QR Code for better user experience
    func showRectOnQRCode(metadataObject: AVMetadataObject) {
        if let visualCodeObject = previewLayer.transformedMetadataObject(for: metadataObject) {
            self.viewScanArea.isHidden = true
            let viewScanArea = UIView.init(frame: visualCodeObject.bounds)
            viewScanArea.layer.borderColor = UIColor.green.cgColor
            viewScanArea.layer.borderWidth = 5.0
            viewPreview.addSubview(viewScanArea)
            viewPreview.bringSubviewToFront(viewScanArea)
        }
    }
// Method to handle code when scanned
    func found(code: String) {
        self.viewModel?.verifySignature(signature: code)
    }
    
}
// Delegate Methods to handle verification response
extension VerificationViewController: VerificationViewDelegate {
    
    func onSuccess() {
        Utils.showSimpleAlert(controller: self, title: "Signature is Valid") { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func onFailure() {
        Utils.showSimpleAlert(controller: self, title: "Oops!! Signature is not Valid") { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func onError(error: ErrorResult?) {
        Utils.showSimpleAlert(controller: self, title: "An error occured", message: error?.localizedDescription, buttonText: "Cancel")
    }

}


// Handle Screen Orientation changes
extension VerificationViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.configureVideoOrientation()
    }

    private func configureVideoOrientation() {

        let orientation: AVCaptureVideoOrientation
        switch UIDevice.current.orientation {
          case .portrait:
            orientation = .portrait
          case .landscapeRight:
            orientation = .landscapeLeft
          case .landscapeLeft:
            orientation = .landscapeRight
          case .portraitUpsideDown:
            orientation = .portraitUpsideDown
          default:
            orientation = .portrait
        }
        if previewLayer.connection?.isVideoOrientationSupported == true {
          previewLayer.connection?.videoOrientation = orientation
        }
        previewLayer.frame = viewPreview.bounds
        
    }
}
