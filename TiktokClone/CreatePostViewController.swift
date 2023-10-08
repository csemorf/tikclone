//
//  CreatePostViewController.swift
//  TiktokClone
//
//  Created by admin on 07/10/2023.
//

import UIKit
import AVFoundation

class CreatePostViewController: UIViewController {

    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var beautyLabel: UILabel!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var flashLabel: UILabel!
    
    
    @IBOutlet weak var timeCounterLabel: UILabel!
    
    
    @IBOutlet weak var speedButton: UIButton!
    @IBOutlet weak var beautyButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!

    
    
    @IBOutlet weak var effectsButton: UIButton!
    
    @IBOutlet weak var galleryButton: UIButton!
    
    @IBOutlet weak var flipLabelButton: UILabel!
    @IBOutlet weak var flipButton: UIButton!
    
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var captureButtonRingView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    let captureSession = AVCaptureSession()
    let photoFileOutput = AVCapturePhotoOutput()
    
    let movieOutput = AVCaptureMovieFileOutput()
    
    var activeInput:AVCaptureDeviceInput!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if setupCaptureSession() {
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
        }
        setupView()// Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = false
        
    }
    func setupView() {
        captureButtonRingView.layer.cornerRadius = 85/2
        captureButton.layer.cornerRadius = 68/2
        
        captureButtonRingView.layer.borderWidth = 6
        
        captureButtonRingView.layer.borderColor = UIColor(red: 254/255, green: 44/255, blue: 85/255, alpha: 0.5).cgColor
        captureButton.backgroundColor = UIColor(red: 254/255, green: 44/255, blue: 85/255, alpha: 1)

        timerLabel.backgroundColor = UIColor.black.withAlphaComponent(0.42)
        timerLabel.textColor = UIColor.white
        
        timeCounterLabel.layer.cornerRadius = 15
        timeCounterLabel.layer.borderWidth = 1.8
        timeCounterLabel.layer.borderColor = UIColor.white.cgColor
        timeCounterLabel.clipsToBounds = true
        
        
        soundsView.layer.cornerRadius = 12
        
        [captureButton,captureButtonRingView,flipButton,flipLabelButton,cancelButton,timeCounterLabel,speedLabel,speedButton,beautyLabel,beautyButton,filterLabel,filterButton,timerLabel,timerButton,flashButton,flashLabel,soundsView,galleryButton,effectsButton].forEach { item in
            item.layer.zPosition = 1
        }
        
    }
    @IBOutlet weak var soundsView: UIView!
    
    func setupCaptureSession()->Bool {
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        if let captureVideoDevice = AVCaptureDevice.default(for: AVMediaType.video),
           let captureAudioDevice = AVCaptureDevice.default(for: .audio) {
            do {
                 let inputVideo = try AVCaptureDeviceInput(device:captureVideoDevice)
                 let inputAudio = try AVCaptureDeviceInput(device:captureAudioDevice)

                
                if captureSession.canAddInput(inputVideo) {
                    captureSession.addInput(inputVideo)
                    activeInput = inputVideo
                }
                if captureSession.canAddInput(inputAudio) {
                    captureSession.addInput(inputAudio)
                }
                
                if captureSession.canAddOutput(movieOutput) {
                    captureSession.addOutput(movieOutput)
                }
            }catch {
                print("cannot setup camera",error.localizedDescription)
                return false
            }
        }
        if captureSession.canAddOutput(photoFileOutput) {
            captureSession.addOutput(photoFileOutput)
        }
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(previewLayer)
        return true
    }
    
    
    @IBAction func flipButtonDidTapped(_ sender: Any) {
        captureSession.beginConfiguration()
    
        let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput
        let newCameraDevice = currentInput?.device.position == .back ? getDeviceFront(position: .front) : getDeviceBack(position: .back)
        
        let newVideoInput = try? AVCaptureDeviceInput(device: newCameraDevice!)
        
        
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                captureSession.removeInput(input)
            }
        }
        if captureSession.inputs.isEmpty {
            captureSession.addInput(newVideoInput!)
            activeInput = newVideoInput
        }
        
        if let microphone = AVCaptureDevice.default(for: .audio) {
            do {
                let micInput =  try AVCaptureDeviceInput(device: microphone)
                
                if captureSession.canAddInput(micInput) {
                    captureSession.addInput(micInput)
                }
            }catch let micError{
                print("error setting device audio input \(micError.localizedDescription)")
                
            }
        }
        
        captureSession.commitConfiguration()
        
        
    }
    
    
    
    func getDeviceFront(position:AVCaptureDevice.Position)->AVCaptureDevice? {
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    }
    func getDeviceBack(position:AVCaptureDevice.Position )->AVCaptureDevice? {
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    }

    @IBAction func cancelCaptureButton(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
}
