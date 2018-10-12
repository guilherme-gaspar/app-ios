//
//  ViewController.swift
//  App
//
//  Created by user145557 on 9/28/18.
//  Copyright © 2018 user145557. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
  
    @IBOutlet weak var imgFacebook: UIImageView!
    @IBOutlet weak var imgApi: UIImageView!
    @IBOutlet weak var imgGit: UIImageView!
    
    
    

    
    @IBAction func btnInfo(_ sender: Any) {
        showInfo()
    }
    @IBAction func btnHome(_ sender: Any) {
        if FBSDKAccessToken.current() != nil {
            showHome()
        } else {
            Alert(controller: self).showDeslogado(message: "Voce precisa estar logado")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "App"
        let btnFBLogin = FBSDKLoginButton()
        btnFBLogin.readPermissions = ["public_profile", "email"]
        btnFBLogin.delegate = self
        
        btnFBLogin.center = self.view.center
        self.view.addSubview(btnFBLogin)
        
        if FBSDKAccessToken.current() != nil {
            imgFacebook.image = UIImage(imageLiteralResourceName: "checked.png")
        } else {
            imgFacebook.image = UIImage(imageLiteralResourceName: "unchecked.png")
        }
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("Algum erro aconteceu")
        } else if result.isCancelled {
            print("Foi cancelado")
        } else {
            self.imgFacebook.image = UIImage(imageLiteralResourceName: "checked.png")
            showHome()
        }
    }
    
    @objc func showHome(){
        let newHome = HomeViewController()
        if let navigation = navigationController {
            navigation.pushViewController(newHome, animated: true)
        } else {
            print("Nao foi possivel")
        }
    }
    
    func showInfo() {
        let newInfo = InfoViewController()
        if let navigation = navigationController {
            navigation.pushViewController(newInfo, animated: true)
        } else {
            print("Nao foi possivel")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        self.imgFacebook.image = UIImage(imageLiteralResourceName: "unchecked.png")
    }


}

