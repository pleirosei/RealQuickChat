//
//  ChatPicture.swift
//  QuickChat
//
//  Created by Sean Livingston on 2/11/15.
//  Copyright (c) 2015 ElevenFifty. All rights reserved.
//

import Foundation

class ChatPicture : PFObject, PFSubclassing {
    override class func load() {
        self.registerSubclass()
    }
    class func parseClassName() -> String! {
        return "ChatPicture"
    }
    
    override init() {
        super.init()
    }
    
    var fromUser : ChatUser {
        get { return objectForKey("fromUser") as ChatUser }
        set { setObject(newValue, forKey: "fromUser") }
    }
    
    var toUser : ChatUser {
        get { return objectForKey("toUser") as ChatUser }
        set { setObject(newValue, forKey: "toUser") }
    }

    var image : PFFile {
        get { return objectForKey("image") as PFFile }
        set { setObject(newValue, forKey: "image") }
    }
    
}