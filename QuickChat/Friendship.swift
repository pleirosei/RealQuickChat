//
//  Friendship.swift
//  QuickChat
//
//  Created by Sean Livingston on 2/11/15.
//  Copyright (c) 2015 ElevenFifty. All rights reserved.
//

import Foundation

class Friendship : PFObject, PFSubclassing {
    override class func load() {
        self.registerSubclass()
    }
    class func parseClassName() -> String! {
        return "Friendship"
    }
    
    override init() {
        super.init()
    }
    
    var currentUser : ChatUser {
        get { return objectForKey("currentUser") as ChatUser }
        set { setObject(newValue, forKey: "currentUser") }
    }
    
    var theFriend : ChatUser {
        get { return objectForKey("theFriend") as ChatUser }
        set { setObject(newValue, forKey: "theFriend") }
    }
    
    var selected = false
    
}