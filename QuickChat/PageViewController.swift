//
//  PageViewController.swift
//  QuickChat
//
//  Created by Sean Livingston on 2/10/15.
//  Copyright (c) 2015 ElevenFifty. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, PFLogInViewControllerDelegate {

    
    var running = false
    
    var cameraViewController : CameraViewController!
    var friendsViewController : FriendsViewController!
    var messageViewController : MessageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if checkAuth() {
            didLoad()
        }
        
        
    }
    
    func didLoad() {
        
        if running { return }
        running = true
    
        self.dataSource = self
        
        cameraViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CameraViewController") as CameraViewController
        
        friendsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FriendsViewController") as FriendsViewController
        
        messageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MessageViewController") as MessageViewController
        
        let startingViewControllers : NSArray = [cameraViewController]
        
        setViewControllers(startingViewControllers, direction: .Forward, animated: false, completion: nil)
        
        // Do any additional setup after loading the view.
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
     
        if viewController === cameraViewController {
            return friendsViewController
        } else if viewController === messageViewController {
            return cameraViewController
        }
        
        return nil
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if viewController === friendsViewController {
            return cameraViewController;
        } else if viewController === cameraViewController {
            return messageViewController
        }
        
        return nil
    }
    
    func checkAuth() -> Bool {
        if PFUser.currentUser() == nil {
            let loginViewController = PFLogInViewController()
            loginViewController.delegate = self
            
            // Show twitter button
            loginViewController.fields = PFLogInFields.Twitter
            
            self.presentViewController(loginViewController, animated: false, completion: nil)
            
            
            return false
        }
        
        return true
    }
    
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        let chatUser = user as ChatUser
        chatUser.twitterHandle = PFTwitterUtils.twitter().screenName.lowercaseString
        chatUser.saveInBackgroundWithBlock(nil)
        
        didLoad()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func sendPhoto(segue:UIStoryboardSegue) {
        println("User tapped sending photo")
        
        // Get the file name
        let (fileName, snapFileName) = Utilities.getSnapFileName()
        
        // Get the view controller we are coming from (source)
        let sendTo = segue.sourceViewController as SendToTableViewController
        
        // A single copy of the file we are about to upload
        var uploadFile = PFFile(name: fileName, contentsAtPath: snapFileName)
        
        // We upload the file one time
        uploadFile.saveInBackgroundWithBlock { (success, _) -> Void in
            
            if success {
                println("Photo uploaded")
                
                // Get list of friends to send it to
                let friends = sendTo.getTargetFriends()
                
                // Send image to every friend
                for friend in friends {
                    // Create a message to the friend
                    let msg = ChatPicture()
                    msg.fromUser = ChatUser.currentUser()
                    msg.toUser = friend
                    msg.image = uploadFile
                    msg.saveInBackgroundWithBlock(nil)
                }
            }
            
        }
        
    }

}
