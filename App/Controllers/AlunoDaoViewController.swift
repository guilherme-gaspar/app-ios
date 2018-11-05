//
//  AlunoDaoViewController.swift
//  App
//
//  Created by user145557 on 10/3/18.
//  Copyright © 2018 user145557. All rights reserved.
//

import UIKit
import CoreData

class AlunoDaoViewController: UIViewController, ImagePickerFotoSelecionada {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var txtFieldNome: UITextField!
    @IBOutlet weak var txtFieldEndereco: UITextField!
    @IBOutlet weak var txtFieldTelefone: UITextField!
    @IBOutlet weak var txtFieldSite: UITextField!
    @IBOutlet weak var viewImagemAluno: UIView!
    @IBOutlet weak var imageAluno: UIImageView!
    @IBOutlet weak var buttonFoto: UIButton!
    
    // MARK: - Variaveis
    
    let imagePicker = ImagePicker()
    var aluno:Aluno?
    var contexto:NSManagedObjectContext {
        let appDelegate =  UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Metodos
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Novo aluno"
        self.arredondaView()
        self.imagePicker.delegate = self
        self.setup()

        // Do any additional setup after loading the view.
    }
    
    func imagePickerFotoSelecionada(_ foto: UIImage) {
        imageAluno.image = foto
    }
    
    func mostrarMultimidia(_ opcao:MenuOpcoes) {
        let multimidia = UIImagePickerController()
        multimidia.delegate = imagePicker
        
        if opcao == .camera && UIImagePickerController.isSourceTypeAvailable(.camera) {
            multimidia.sourceType = .camera
        }
        else {
            multimidia.sourceType = .photoLibrary
        }
        self.present(multimidia, animated: true, completion: nil)
    }
    
    func setup() -> Void {
        guard let alunoSelecionado = aluno else { return }
        txtFieldNome.text = alunoSelecionado.nome
        txtFieldSite.text = alunoSelecionado.site
        txtFieldEndereco.text = alunoSelecionado.endereco
        txtFieldTelefone.text = alunoSelecionado.telefone
        imageAluno.image = alunoSelecionado.foto as? UIImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func arredondaView() {
        self.viewImagemAluno.layer.cornerRadius = self.viewImagemAluno.frame.width / 2
        self.viewImagemAluno.layer.borderWidth = 1
        self.viewImagemAluno.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func btnSalvar(_ sender: UIButton) {
        if aluno == nil {
            aluno = Aluno(context: contexto)
        }
        aluno?.nome = txtFieldNome.text
        aluno?.endereco = txtFieldEndereco.text
        aluno?.telefone = txtFieldTelefone.text
        aluno?.site = txtFieldSite.text
        aluno?.foto = imageAluno.image
        do {
            try contexto.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func buttonFoto(_ sender: UIButton) {
        
        let menu = ImagePicker().menuDeOpcoes { (opcao) in
            self.mostrarMultimidia(opcao)
        }
        present(menu, animated: true, completion: nil)
    }
    

}
