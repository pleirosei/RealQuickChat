//
//  FriendsViewController.swift
//  QuickChat
//
//  Created by Sean Livingston on 2/10/15.
//  Copyright (c) 2015 ElevenFifty. All rights reserved.
//

import UIKit

class FriendsViewController: PFQueryTableViewController, UISearchBarDelegate {
    
    var searchText = ""
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = Friendship.parseClassName()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        //        let friends = Friendship()
        //        friends.currentUser = ChatUser.currentUser()
        //        friends.theFriend = ChatUser.currentUser()
        //        friends.saveInBackgroundWithBlock(nil)
        
    }
    
    override func queryForTable() -> PFQuery! {
        
        if searchText.isEmpty {
            var query = Friendship.query()
            query.whereKey("currentUser", equalTo: ChatUser.currentUser())
            query.includeKey("theFriend")
            
            return query
        } else {
            var query = ChatUser.query()
            query.whereKey("twitterHandle", containsString: searchText.lowercaseString)
            query.whereKey("objectId", notEqualTo: ChatUser.currentUser().objectId)
            return query
        }
    }
    
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
        
        // Get a cell
        var cell = tableView.dequeueReusableCellWithIdentifier("PFTableViewCell") as PFTableViewCell!
        
        if object is Friendship {
            // Convert to friendship
            var friend = object as Friendship
            
            // show friends twitter handle
            cell.textLabel?.text = friend.theFriend.twitterHandle
        } else if object is ChatUser {
            // Convert to chat user
            var user = object as ChatUser
            
            // show user's twitter handle
            cell.textLabel?.text = user.twitterHandle
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedObject = objectAtIndexPath(indexPath)
        
        if selectedObject is ChatUser {
            // Ask the user if they want to add them as a friend
            addFriend(selectedObject as ChatUser)
            // Maybe remove them from search results
            // Pro Mode: Follow / Unfollow button in search results
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    // short-circuit
    var addingFriends = false
    
    func addFriend(friend:ChatUser) {
        // Bail out if we are already adding friends
        if addingFriends { return }
        addingFriends = true
        
        // Check to see if we are already friends
        var areFriends = Friendship.query()
        areFriends.whereKey("currentUser", equalTo: ChatUser.currentUser())
        areFriends.whereKey("theFriend", equalTo: friend)
        areFriends.countObjectsInBackgroundWithBlock { (count, _) in
            if count > 0 {
                println("Not adding, already friends")
                self.addingFriends = false
            } else {
                // Not friends yet, lets trade bracelets
                let friends = Friendship()
                friends.currentUser = ChatUser.currentUser()
                friends.theFriend = friend
                friends.saveInBackgroundWithBlock() { (_, _) in
                    // Re-enable adding friends
                    self.addingFriends = false
                }
            }
        }
        
    }
    
    
    // MARK: - Search bar stuff
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // reset state
        searchBar.text = nil
        searchText = ""
        // Hide the keyboard
        searchBar.resignFirstResponder()
        // reload data
        self.loadObjects()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // save state
        searchText = searchBar.text
        // hide keyboard
        searchBar.resignFirstResponder()
        // reload data
        self.loadObjects()
    }
    
}