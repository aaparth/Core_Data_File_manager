//
//  ViewController.swift
//  Core_Data_File_manager
//
//  Created by ParthSoni on 22/12/17.
//  Copyright © 2017 ParthSoni. All rights reserved.
//

import UIKit
import CoreData

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
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            self.save(name: nameToSave, completionBloack: { (success) in
                if success{
                    self.tableView.reloadData()
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        alert.addTextField()
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true)
    }
    
    func save(name: String, completionBloack:((Bool)->Void)?){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            completionBloack!(false)
            return
        }
        
        let personId = "\(self.personObj.count + 1)"
        let imageKey = "\(name)_\(personId)"
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        let image = UIImage(named: "img.png")
        PDCache.sharedInstance.saveImage(image: image!, Key: imageKey)
        
        person.setValue(personId, forKey: "id")
        person.setValue(imageKey, forKey: "image")
        person.setValue(name, forKey: "name")
        
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
        
        if let imgUrl = singlePersonObj.value(forKey: "image") as? String{
            if let userImage = PDCache.sharedInstance.getImage(Key: imgUrl){
                cell.imgUser.image = userImage
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}

