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
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var viewBotaoHome: UIView!
    
    // MARK: - Variaveis
    
    var birthDayString:String = ""
    var genderString:String = ""
    var nameString:String = ""
    var emailString:String = ""
    
    // MARK: - Metodos
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Principal"
        addBarItem()
        fetchProfile()
        self.viewBotaoHome.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
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
    }
    
    func fetchProfile(){
        let parameters = ["fields": "email, birthday, gender, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            
            guard let userInfo = result as? [String:Any] else {return}
            if error != nil {
                print(error as Any)
                return
            }
            if let birthday = userInfo["birthday"] as? String {
                self.birthDayString = birthday
                
            }
            if let gender = userInfo["gender"] as? String {
                self.genderString = gender
                
            }
            if let email = userInfo["email"] as? String {
                self.emailString = email
                self.lblEmail.text = email
            }
            if let nome = userInfo["first_name"] as? String {
                self.lblName.text = nome
                self.nameString = nome
            }
            if let imageURLFromResult = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                let imageURL = URL(string: imageURLFromResult)!
                let imageData = try! Data(contentsOf: imageURL)
                let image = UIImage(data: imageData)
                self.imgProfile.image = image
                self.imgProfile.contentMode = UIViewContentMode.scaleAspectFit
                self.viewImage.layer.cornerRadius = self.imgProfile.frame.width / 2
            }
        }
    }
    
    @IBAction func btnHome(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnApi(_ sender: Any) {
        let api = ApiTableViewController()
        navigationController?.pushViewController(api, animated: true)
    }
    
    @IBAction func btnDados(_ sender: Any) {
        let dao = DaoTableViewController()
        navigationController?.pushViewController(dao, animated: true)
    }
    
    @IBAction func btnPerfil(_ sender: Any) {
        let details = UIAlertController(title: "Perfil", message: "Nome: \(nameString)\nEmail: \(emailString)\nData de aniversario: \(birthDayString) \nGenero: \(genderString)", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        details.addAction(ok)
        self.present(details, animated: true, completion: nil)
        
    }
    
    @IBAction func btnInfo(_ sender: Any) {
        let info = InfoViewController()
        navigationController?.pushViewController(info, animated: true)
    }
    
    
    
    

}
