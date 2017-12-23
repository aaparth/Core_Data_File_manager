//
//  PopupVC.swift
//  Core_Data_File_manager
//
//  Created by ParthSoni on 22/12/17.
//  Copyright © 2017 ParthSoni. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import MobileCoreServices

class PopupVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var txtName: UITextField!
    
    @IBOutlet var playerView: UIView!
    
    var obj = ImgVideo()
    var player = AVPlayer()
    
    var saveData: ((String, ImgVideo)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func selectImageTapped(_ sender: UIButton){
        self.openPicker()
    }
    
    @IBAction func saveTapped(_ sender: UIButton){
//        let data = UIImagePNGRepresentation(self.imgUser.image!)
        self.player.pause()
        self.saveData!(self.txtName.text!, obj)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- ImagePicker delegate
    func openPicker(){
        let imgPickerController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        imgPickerController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.openImagePicker(sourceType: .camera)
        }))
        imgPickerController.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.openImagePicker(sourceType: .photoLibrary)
        }))
        imgPickerController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(imgPickerController, animated: true, completion: nil)
    }
    
    func openImagePicker(sourceType: UIImagePickerControllerSourceType){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = sourceType
        picker.mediaTypes = ["public.image", "public.movie"]
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as? String
        if mediaType != nil || mediaType != ""{
            if mediaType! == "public.movie"{
                if (mediaType == (kUTTypeVideo as? String)) || (mediaType == (kUTTypeMovie as? String)) {
                    let videoURL = info[UIImagePickerControllerMediaURL] as! URL
                    self.obj.isVideo = true
                    self.obj.videoUrl = "\(videoURL)"
                    self.playVideo()
//                    let videoData = NSData(contentsOf: videoURL)
                }
            } else{
                let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
                self.obj.image = chosenImage
                self.imgUser.image = chosenImage
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Play Video
    
    func playVideo(){
        self.player = AVPlayer(url: URL(string: self.obj.videoUrl)!)
        let avPlayerLayer:AVPlayerLayer = AVPlayerLayer(player: player)
        avPlayerLayer.frame = CGRect(x: 0, y: 0, width: self.playerView.bounds.width, height: self.playerView.bounds.height)
        self.playerView.layer.addSublayer(avPlayerLayer)
        player.play()
        
    }
    
}
