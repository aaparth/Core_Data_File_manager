//
//  PDCache.swift
//  Core_Data_File_manager
//
//  Created by ParthSoni on 22/12/17.
//  Copyright © 2017 ParthSoni. All rights reserved.
//

import UIKit

class PDCache: NSObject {
    
    static let sharedInstance = PDCache()
    
    func saveImage(image: UIImage, Key: String) {
        if let data = UIImagePNGRepresentation(image) {
            let filename = getDocumentsDirectory().appendingPathComponent("\(Key).png")
            print(filename)
            do{
                try data.write(to: filename)
            } catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func saveImageData(imageData: Data, Key: String){
            let filename = getDocumentsDirectory().appendingPathComponent("\(Key).png")
            print(filename)
        do{
            try imageData.write(to: filename)
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func getImage(Key: String) -> UIImage?{
        let fileManager = FileManager.default
        let filename = getDocumentsDirectory().appendingPathComponent("\(Key).png")
        if fileManager.fileExists(atPath: filename.path) {
            return UIImage(contentsOfFile: filename.path)
        }
        return nil
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

