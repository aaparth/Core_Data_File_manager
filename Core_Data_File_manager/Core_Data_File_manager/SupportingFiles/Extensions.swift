//
//  Extensions.swift
//  Core_Data_File_manager
//
//  Created by ParthSoni on 26/12/17.
//  Copyright © 2017 ParthSoni. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
