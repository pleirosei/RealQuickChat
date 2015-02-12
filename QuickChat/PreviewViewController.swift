//
//  PreviewViewController.swift
//  QuickChat
//
//  Created by Sean Livingston on 2/11/15.
//  Copyright (c) 2015 ElevenFifty. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let (_, fileName) = Utilities.getSnapFileName()
        
        imageView.image = UIImage(contentsOfFile: fileName)
        imageView.contentMode = .ScaleAspectFill
        // Do any additional setup after loading the view.
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
