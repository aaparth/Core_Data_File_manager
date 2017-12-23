//
//  ViewController.swift
//  Core_Data_File_manager
//
//  Created by ParthSoni on 22/12/17.
//  Copyright © 2017 ParthSoni. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import MediaPlayer

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var personObj: [NSManagedObject] = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TVCell", bundle: nil), forCellReuseIdentifier: "TVCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do{
            personObj = try managedContext.fetch(fetchRequest)
        } catch{
            print("Error fetching data")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Button Actions
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        
        let requestVC : PopupVC  = self.storyboard!.instantiateViewController(withIdentifier: "PopupVC") as! PopupVC
        requestVC.saveData = { name, obj in
            requestVC.dismiss(animated: true, completion: {
                self.save(name: name, image: obj, completionBloack: { (success) in
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            })
        }
        requestVC.providesPresentationContextTransitionStyle = true;
        requestVC.definesPresentationContext = true;
        requestVC.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
        self.present(requestVC, animated: true, completion: nil)
    }
    
    func save(name: String,image: ImgVideo, completionBloack:((Bool)->Void)?){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            completionBloack!(false)
            return
        }
        
        let personId = "\(self.personObj.count + 1)"
        let imageKey = "\(name)_\(personId)"
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        PDCache.sharedInstance.saveData(obj: image, Key: imageKey)
        
        person.setValue(personId, forKey: "id")
        person.setValue(imageKey, forKey: "image")
        person.setValue(name, forKey: "name")
        
        if image.isVideo{
            person.setValue(true, forKey: "isVideo")
        } else{
            person.setValue(false, forKey: "isVideo")
        }
        
        do{
            try managedContext.save()
            self.personObj.append(person)
            completionBloack!(true)
        } catch{
            completionBloack!(false)
        }
    }
    
    //MARK:- UITableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personObj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVCell", for: indexPath) as! TVCell
        
        let singlePersonObj = self.personObj[indexPath.row]
        
        if singlePersonObj.value(forKey: "name") is String{
            cell.lblName.text = singlePersonObj.value(forKey: "name") as? String
        }
        
        if let isVideo = singlePersonObj.value(forKey: "isVideo") as? Bool{
            if let imgUrl = singlePersonObj.value(forKey: "image") as? String{
                if isVideo{
                    if let url = PDCache.sharedInstance.getData(Key: imgUrl){
                        let player = AVPlayer(url: url)
                        let avPlayerLayer:AVPlayerLayer = AVPlayerLayer(player: player)
                        avPlayerLayer.frame = CGRect(x: 0, y: 0, width: cell.imgUser.bounds.width, height: cell.imgUser.bounds.height)
                        cell.imgUser.layer.addSublayer(avPlayerLayer)
                        cell.imgUser.clipsToBounds = true
                        player.play()
                    }
                } else{
                    if let userImage = PDCache.sharedInstance.getImage(Key: imgUrl){
                        cell.imgUser.image = userImage
                    }
                }
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

