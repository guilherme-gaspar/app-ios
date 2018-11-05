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
    
    // MARK: - Metodos
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "App"
        let btnFBLogin = FBSDKLoginButton()
        btnFBLogin.readPermissions = ["public_profile", "email", "user_birthday", "user_gender"]
        btnFBLogin.delegate = self
        btnFBLogin.setTitle("Login com o Facebook", for: UIControlState.normal)
        let newCenter = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height - 60)
        btnFBLogin.center = newCenter
        self.view.addSubview(btnFBLogin)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if FBSDKAccessToken.current() != nil {
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("Algum erro aconteceu")
        } else if result.isCancelled {
            print("Foi cancelado")
        } else {
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
        
    }


}

