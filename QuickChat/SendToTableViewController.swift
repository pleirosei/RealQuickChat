//
//  SendToTableViewController.swift
//  QuickChat
//
//  Created by Eleven Fifty on 2/11/15.
//  Copyright (c) 2015 ElevenFifty. All rights reserved.
//
// http://pastebin.com/qD8WN36f

import UIKit

class SendToTableViewController: PFQueryTableViewController {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.parseClassName = Friendship.parseClassName()
    }
    
    override func queryForTable() -> PFQuery! {
        var query = Friendship.query()
        query.whereKey("currentUser", equalTo: ChatUser.currentUser())
        query.includeKey("theFriend")
        
        return query
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SendToTableViewCell") as SendToTableViewCell
        
        cell.setupCell(object as Friendship)
        
        return cell
        
    }
    
    func getTargetFriends() -> [ChatUser] {
        var targetFriends = [ChatUser]()
        
        let friends = self.objects as [Friendship]
        
        for friend in friends {
            if friend.selected {
                targetFriends.append(friend.theFriend)
            }
        }
        
        return targetFriends
    }
    
    
}