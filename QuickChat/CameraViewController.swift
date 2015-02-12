//
//  CameraViewController.swift
//  QuickChat
//
//  Created by Sean Livingston on 2/10/15.
//  Copyright (c) 2015 ElevenFifty. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    
    @IBOutlet weak var cameraView : UIView!
    
    // Our way of talking to AVFoundation
    private let captureSession = AVCaptureSession()
    // The camera
    private var captureDevice : AVCaptureDevice?
    // What the camera sees
    private var previewLayer : AVCaptureVideoPreviewLayer?
    // Which camera are we actively using
    private var cameraPosition = AVCaptureDevicePosition.Back
    // Interface to save images from the camera
    private var stillImageOutput : AVCaptureStillImageOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if findCamera() {
            beginSession()
        } else {
            // Show sad message to the user
        }
    }
    
    
    
    private func findCamera () -> Bool {
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        
        for device in devices {
            if device.position == cameraPosition {
                captureDevice = device as? AVCaptureDevice
                return captureDevice != nil
            }
        }
        
        captureDevice = nil
        return false
    }
    
    private func beginSession() {
        var err : NSError?
        
        let videoCapture = AVCaptureDeviceInput(device: captureDevice, error: &err)
        
        // bail if there are any errors
        if err != nil {
            println("Couldn't start session: \(err?.localizedDescription)")
            return
        }
        
        // check to see if we can add inputs at this time
        if captureSession.canAddInput(videoCapture) {
            captureSession.addInput(videoCapture)
        }
        
        // Do some first time only setup
        if !captureSession.running {
            //setup JPEG output
            stillImageOutput = AVCaptureStillImageOutput()
            let outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
            stillImageOutput!.outputSettings = outputSettings
            
            // check to see if we can add outputs at this time
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
            
            // Display in the UI
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            cameraView.layer.addSublayer(previewLayer)
            previewLayer?.frame = self.view.layer.frame
            previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            
            // Start Camera
            captureSession.startRunning()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func flipCamera(sender:UIButton) {
        captureSession.beginConfiguration()
        
        // get the input we are on and remove it
        let currentInput = captureSession.inputs[0] as AVCaptureInput
        captureSession.removeInput(currentInput)
        
        cameraPosition = cameraPosition == .Back ? .Front : .Back
        // find and add other camera
        if findCamera() {
            beginSession()
        } else {
            // show sad message
        }
        
        captureSession.commitConfiguration()
        
        
    }
    // http://pastebin.com/kB0S0Uyx
    
    @IBAction func takePhoto(sender:UIButton) {
        if let stillOutput = self.stillImageOutput {
            
            // We do this on another thread so we don't hang the UI
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                
                // Find the video connection
                var videoConnection : AVCaptureConnection?
                for connection in stillOutput.connections
                {
                    for port in connection.inputPorts!
                    {
                        if port.mediaType == AVMediaTypeVideo
                        {
                            videoConnection = connection as? AVCaptureConnection
                            break;
                        }
                    }
                    if videoConnection != nil
                    {
                        break;
                    }
                }
                
                if videoConnection != nil {
                    // Found the video connection, let's get the image
                    stillOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (imageSampleBuffer:CMSampleBuffer!,error: NSError!) -> Void in
                        
                        let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer)
                        
                        self.didTakePhoto(imageData)
                        
                    })
                }
                
            }
        }
        
    }
    
    
    func didTakePhoto(imageData: NSData) {
        // If you wanted to show a thumbnail in the UI:
        
        let image = UIImage(data: imageData)
        let compressedImage = compressImage(image!)
        
        let (_, fileName) = Utilities.getSnapFileName()
        compressedImage.writeToFile(fileName, atomically: true)
        
        performSegueWithIdentifier("PreviewSegue", sender: self)
        
//        var sendNav = self.storyboard?.instantiateViewControllerWithIdentifier("SendNav") as UINavigationController!
//        self.presentViewController(sendNav, animated: true, completion: nil)
        
        /* You can verify the file exists and view it by
        1: In Xcode go to Window -> Devices
        2: Pick your device
        3: Pick your app
        4: Click the Gear below the app list and choose download container
        5: Save the file to somewhere (i.e. desktop)
        6: Right-click and pick Show Package Contents
        7: Navigate to your temporary folder
        */
    }
    
    func compressImage(image:UIImage) -> NSData {
        // Drops from 2MB -> 64 KB!!!
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        var maxHeight : CGFloat = 1136.0
        var maxWidth : CGFloat = 640.0
        var imgRatio : CGFloat = actualWidth/actualHeight
        var maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = 0.5
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else{
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        var rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
        UIGraphicsBeginImageContext(rect.size);
        image.drawInRect(rect)
        var img = UIGraphicsGetImageFromCurrentImageContext();
        let imageData = UIImageJPEGRepresentation(img, compressionQuality);
        UIGraphicsEndImageContext();
        
        return imageData;
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
