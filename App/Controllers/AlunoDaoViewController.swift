//
//  AlunoDaoViewController.swift
//  App
//
//  Created by user145557 on 10/3/18.
//  Copyright © 2018 user145557. All rights reserved.
//

import UIKit
import CoreData

class AlunoDaoViewController: UIViewController {

    
    @IBOutlet weak var txtFieldNome: UITextField!
    @IBOutlet weak var txtFieldEndereco: UITextField!
    @IBOutlet weak var txtFieldTelefone: UITextField!
    @IBOutlet weak var txtFieldSite: UITextField!
    var aluno:Aluno?
    
    var contexto:NSManagedObjectContext {
        let appDelegate =  UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Novo aluno"
        self.setup()

        // Do any additional setup after loading the view.
    }
    
    func setup() -> Void {
        guard let alunoSelecionado = aluno else { return }
        txtFieldNome.text = alunoSelecionado.nome
        txtFieldSite.text = alunoSelecionado.site
        txtFieldEndereco.text = alunoSelecionado.endereco
        txtFieldTelefone.text = alunoSelecionado.telefone
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func btnSalvar(_ sender: UIButton) {
        if aluno == nil {
            aluno = Aluno(context: contexto)
        }
        aluno?.nome = txtFieldNome.text
        aluno?.endereco = txtFieldEndereco.text
        aluno?.telefone = txtFieldTelefone.text
        aluno?.site = txtFieldSite.text
        do {
            try contexto.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    

}
