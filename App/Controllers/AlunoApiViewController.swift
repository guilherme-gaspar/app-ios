//
//  AlunoApiViewController.swift
//  App
//
//  Created by user145557 on 10/8/18.
//  Copyright © 2018 user145557. All rights reserved.
//

import UIKit

class AlunoApiViewController: UIViewController {
    
    @IBOutlet weak var txtFieldNome: UITextField!
    @IBOutlet weak var txtFieldEndereco: UITextField!
    @IBOutlet weak var txtFieldTelefone: UITextField!
    @IBOutlet weak var txtFieldSite: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func montaDicionarioDeParametros() -> Dictionary<String, String> {
        guard let nome = txtFieldNome.text else { return [:] }
        guard let endereco = txtFieldEndereco.text else { return [:] }
        guard let telefone = txtFieldTelefone.text else { return [:] }
        guard let site = txtFieldSite.text else { return [:] }
        
        let dicionario:Dictionary<String, String> = [
            "id" : String(describing: UUID()),
            "nome" : nome,
            "endereco" : endereco,
            "telefone" : telefone,
            "site" : site
        ]
        return dicionario
    }
    

    @IBAction func btnSalvar(_ sender: UIButton) {
        let json = montaDicionarioDeParametros()
        AlunoApi().salvaAlunosNoServidor(parametros: [json])
        navigationController?.popViewController(animated: true)
    }
    
}
