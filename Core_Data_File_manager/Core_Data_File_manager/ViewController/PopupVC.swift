//
//  PopupVC.swift
//  Core_Data_File_manager
//
//  Created by ParthSoni on 22/12/17.
//  Copyright © 2017 ParthSoni. All rights reserved.
//

import UIKit
import MobileCoreServices

class PopupVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var txtName: UITextField!
    
    var saveData: ((String, Data)->Void)?
    
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
        let data = UIImagePNGRepresentation(self.imgUser.image!)
        self.saveData!(self.txtName.text!, data!)
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
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        dismiss(animated: true, completion: {
            self.imgUser.image = chosenImage
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
