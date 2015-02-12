//
//  ChatUser.swift
//  QuickChat
//
//  Created by Sean Livingston on 2/11/15.
//  Copyright (c) 2015 ElevenFifty. All rights reserved.
//

import Foundation

class ChatUser : PFUser, PFSubclassing {
    override class func load() {
        self.registerSubclass()
    }
    
    var twitterHandle : String {
        get { return objectForKey("twitterHandle") as String }
        set { setObject(newValue, forKey: "twitterHandle") }
    }
    
}