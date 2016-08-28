//
//  LoginViewController.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 27/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    var eventHandler : LoginModuleInterface?
    
    //Outlets
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupViewAppearances() {
        loginButton.tintColor = UIColor.whiteColor()
        
        loginButton.setTitle(LocalizeManager.loginString, forState: .Normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFontOfSize(24)
        loginButton.setBackgroundImage(TwittYxStyleKit.imageOfPixelPrimaryColor, forState: .Normal)
        
        loginButton.setImage(TwittYxStyleKit.imageOfLogoWhite(frame: CGRect(x: 0, y: 0, width: 49.3, height: 40.1)), forState: .Normal)
        loginButton.clipsToBounds = true
        loginButton.layer.cornerRadius = 15
        
    }

    //Actions
    @IBAction func loginButtonTapped() {
        eventHandler?.loginAction()
    }
}
