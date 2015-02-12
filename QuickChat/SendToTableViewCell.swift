//
//  SendToTableViewCell.swift
//  QuickChat
//
//  Created by Eleven Fifty on 2/11/15.
//  Copyright (c) 2015 ElevenFifty. All rights reserved.
//

import UIKit

class SendToTableViewCell: PFTableViewCell {

    @IBOutlet weak var checkBox: UIImageView!
    
    var theFriendship : Friendship!
    
    func setupCell(friends:Friendship) {
        // save the friends
        theFriendship = friends
        // show their name
        textLabel?.text = friends.theFriend.twitterHandle
        // update checkbox
        updateCheckBox()
    }
    
    func updateCheckBox() {
        var imageName = theFriendship.selected ? "checkbox_checked" : "checkbox_unchecked"
        
        checkBox.image = UIImage(named: imageName)
    }

    @IBAction func checkBoxTapped(sender: UIButton) {
        theFriendship.selected = !theFriendship.selected
        updateCheckBox()
    }
}
