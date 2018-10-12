//
//  HomeViewController.swift
//  App
//
//  Created by user145557 on 9/29/18.
//  Copyright © 2018 user145557. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Principal"
        addBarItem()
        fetchProfile()
        // Do any additional setup after loading the view.
    }
    
    func addBarItem() -> Void {
        let logout = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(logoutFb))
        navigationItem.rightBarButtonItem = logout
        
    }
    
    @objc func logoutFb() -> Void {
        
        let alert = UIAlertController(title: "Sair da conta", message: "Voce tem certeza?", preferredStyle: UIAlertControllerStyle.alert)
        
        let ok = UIAlertAction(title: "Sim", style: UIAlertActionStyle.destructive, handler: { action in
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            self.navigationController?.popViewController(animated: true)
        })
        
        let nao = UIAlertAction(title: "Nao", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(nao)
        self.present(alert, animated: true, completion: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchProfile(){
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            
            guard let userInfo = result as? [String:Any] else {return}
            
            if error != nil {
                print(error as Any)
                return
            }
            
            if let email = userInfo["email"] as? String {
                print(email)
                self.lblEmail.text = email
            }
            if let nome = userInfo["first_name"] as? String {
                self.lblName.text = nome
            }
            
            if let imageURLFromResult = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                print(imageURLFromResult)
                
                let imageURL = URL(string: imageURLFromResult)!
                
                let imageData = try! Data(contentsOf: imageURL)
                let image = UIImage(data: imageData)
                self.imgProfile.image = image
                self.imgProfile.contentMode = UIViewContentMode.scaleAspectFit
            }
        }
    }
    
    
    @IBAction func btnArquivo(_ sender: Any) {
        print("Arquivo")
    }
    
    @IBAction func btnApi(_ sender: Any) {
        let api = ApiTableViewController()
        navigationController?.pushViewController(api, animated: true)
    }
    
    @IBAction func btnDados(_ sender: Any) {
        let dao = DaoTableViewController()
        navigationController?.pushViewController(dao, animated: true)
    }
    
    @IBAction func btnSecurity(_ sender: Any) {
        print("Security")
    }
    

}
