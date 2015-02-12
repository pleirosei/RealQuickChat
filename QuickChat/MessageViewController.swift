//
//  MessageViewController.swift
//  QuickChat
//
//  Created by Sean Livingston on 2/10/15.
//  Copyright (c) 2015 ElevenFifty. All rights reserved.
//

import UIKit

class MessageViewController : PFQueryTableViewController, UIGestureRecognizerDelegate {
    
    var fullScreenImage : UIImageView?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.parseClassName = ChatPicture.parseClassName()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var lpgr = UILongPressGestureRecognizer(target: self, action: "longPress:")
        lpgr.minimumPressDuration = 0.1
        lpgr.delegate = self
        self.tableView.addGestureRecognizer(lpgr)
    }
    
    func longPress(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .Began {
            // show it
            var point = gestureRecognizer.locationInView(self.tableView)
            if let indexPath = tableView.indexPathForRowAtPoint(point) {
                // setup preview view
                if fullScreenImage == nil {
                    fullScreenImage = UIImageView(frame: self.view.frame)
                    fullScreenImage?.contentMode = .ScaleAspectFill
                    self.view.window?.addSubview(fullScreenImage!)
                }
                
                var message = objectAtIndexPath(indexPath) as ChatPicture
                let userImageFile = message.image as PFFile
                userImageFile.getDataInBackgroundWithBlock {
                    (imageData: NSData!, error: NSError!) in
                    if error == nil {
                        self.fullScreenImage?.image = UIImage(data:imageData)
                        self.fullScreenImage?.hidden = false
                    }
                }
                
            }
            
            
            
        } else if gestureRecognizer.state == .Ended {
            // hide it
            self.fullScreenImage?.hidden = true
            self.fullScreenImage?.image = nil
        }
        
    }
    
    override func queryForTable() -> PFQuery! {
        var query : PFQuery!
        
        query = ChatPicture.query()
        query.whereKey("toUser", equalTo: ChatUser.currentUser())
        query.includeKey("fromUser")
        
        return query
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("PFTableViewCell") as PFTableViewCell
        
        var message = object as ChatPicture
        
        cell.textLabel?.text = message.fromUser.twitterHandle
        cell.imageView?.file = message.image
        
        return cell
    }
    
}
