//
//  Utilities.swift
//  QuickChat
//
//  Created by Sean Livingston on 2/11/15.
//  Copyright (c) 2015 ElevenFifty. All rights reserved.
//

import Foundation

class Utilities {
    
    class func getSnapFileName() -> (String, String) {
        
        let fileName = "lastSnap.jpg"
        
        let tmpDirectory = NSTemporaryDirectory()
        let snapFileName = tmpDirectory.stringByAppendingPathComponent(fileName)
        
        return (fileName, snapFileName)
    }
    
}