//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    
//  method run just before the view load.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        to hide the navigation bar
        navigationController?.navigationBar.isHidden = true
    }
    
//    methode run the viewcontroller chnage
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = ""
        var i = 0.0
        for letter in "⚡️FlashChat"{
        
            Timer.scheduledTimer(withTimeInterval: 0.1 * i, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
                
            }
                
            i = i+1
            
        }
    }
    

}
