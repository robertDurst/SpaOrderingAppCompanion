//
//  ViewController.swift
//  SPA iPad App
//
//  Created by Coder on 2/23/16.
//  Copyright © 2016 OWA. All rights reserved.
//

import UIKit

let backendless = Backendless.sharedInstance()

class ViewController: UIViewController {
    
     let tapRecKeyBoardHider = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Important Initializers
        let height = UIScreen.mainScreen().bounds.height
        let width = UIScreen.mainScreen().bounds.width
        self.navigationController?.navigationBarHidden = true
        
        //Create background image
        let imageName = "Image"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        view.addSubview(imageView)
        
        
        //Create the tap recognition for the action to hide keyboard
        tapRecKeyBoardHider.addTarget(self, action: "screenTapped")
        view.addGestureRecognizer(tapRecKeyBoardHider)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func screenTapped(){
        performSegueWithIdentifier("nextPage", sender: nil)
    }


}

