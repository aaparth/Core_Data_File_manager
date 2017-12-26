//
//  ImgVideo.swift
//  Core_Data_File_manager
//
//  Created by ParthSoni on 23/12/17.
//  Copyright © 2017 ParthSoni. All rights reserved.
//

import UIKit
import CoreData

class ImgVideo: NSObject {
    
    var image: UIImage?
    var isVideo:Bool = false
    var videoUrl:String = ""
    
}



class PersonEntry: NSManagedObject{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonEntry> {
        return NSFetchRequest<PersonEntry>(entityName: "Person")
    }
    
    @NSManaged var name: String?
    @NSManaged var image: String?
    @NSManaged var isVideo: NSNumber?
    
    var video: Bool {
        get {
            return isVideo == NSNumber(value: true)
        }
        set {
            isVideo = NSNumber(value: newValue)
        }
    }
    
}
