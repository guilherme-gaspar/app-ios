//
//  DaoTableViewController.swift
//  App
//
//  Created by user145557 on 10/3/18.
//  Copyright © 2018 user145557. All rights reserved.
//

import UIKit
import CoreData

class DaoTableViewController: UITableViewController, NSFetchedResultsControllerDelegate  {
    
    // MARK: - Variaveis
    
    var mensagem = Mensagem()
    
    var gerenciadorDeResultados:NSFetchedResultsController<Aluno>?
    var contexto:NSManagedObjectContext {
        let appDelegate =  UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Metodos
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Registrar a celula personalizada para funcionar
        tableView.register(UINib.init(nibName: "DaoTableViewCell", bundle: nil), forCellReuseIdentifier: "CellDao")
        self.addBarItem()
        self.recuperaAlunos()
        self.title = "Alunos"
    }
    
    func recuperaAlunos() -> Void {
        let pesquisaAluno:NSFetchRequest<Aluno> = Aluno.fetchRequest()
        let ordenaPorNome = NSSortDescriptor(key: "nome", ascending: true)
        pesquisaAluno.sortDescriptors = [ordenaPorNome]
        
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaAluno, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        gerenciadorDeResultados?.delegate = self
        
        do {
            try gerenciadorDeResultados?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addBarItem() -> Void {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAlunoDao))
        navigationItem.rightBarButtonItem = add
        
    }

    @objc func addAlunoDao() -> Void {
        let newAluno = AlunoDaoViewController()
        navigationController?.pushViewController(newAluno, animated: true)
    }
    
    @objc func abrirActionSheet(_ longPress:UILongPressGestureRecognizer) {
        if longPress.state == .began {
            guard let alunoSelecionado = gerenciadorDeResultados?.fetchedObjects?[(longPress.view?.tag)!] else { return }
            let menu = MenuOpcoesAlunos().configuraMenuDeOpcoesDoAluno(completion: { (opcao) in
                switch opcao {
                case .sms:
                    if let componenteMensagem = self.mensagem.configuraSMS(alunoSelecionado, self) {
                        componenteMensagem.messageComposeDelegate = self.mensagem
                        self.present(componenteMensagem, animated: true, completion: nil)
                    }
                    break
                case .ligacao:
                    print("Ligar")
                    break
                case .waze:
                    if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
                        guard let enderecoDoAluno = alunoSelecionado.endereco else { return }
                        Localizacao().converteEnderecoEmCoordenadas(endereco: enderecoDoAluno, local: { (localizacaoEncontrada) in
                            let latitude = String(describing: localizacaoEncontrada.location!.coordinate.latitude)
                            let longitude = String(describing: localizacaoEncontrada.location!.coordinate.longitude)
                            let url:String = "waze://?ll=\(latitude),\(longitude)&navigate=yes"
                            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
                        })
                    } else {
                        let alert = UIAlertController(title: "Desculpa", message: "Voce nao tem Waze", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil )
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    break
                case .mapa:
                    let mapa = MapaViewController()
                    mapa.aluno = alunoSelecionado
                    self.navigationController?.pushViewController(mapa, animated: true)
                    break
                case .abrirPaginaWeb:
                    print("WEB")
                    break
                }
            })
            self.present(menu, animated: true, completion: nil)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let contadorListaDeAlunos = gerenciadorDeResultados?.fetchedObjects?.count else { return 0 }
        return contadorListaDeAlunos
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "CellDao", for: indexPath) as! DaoTableViewCell
        celula.tag = indexPath.row
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(abrirActionSheet(_:)))
        
        guard let aluno = gerenciadorDeResultados?.fetchedObjects![indexPath.row] else { return celula }
        
        celula.configuraCelula(aluno)
        celula.addGestureRecognizer(longPress)
        
        return celula
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let alunoSelecionado = gerenciadorDeResultados?.fetchedObjects![indexPath.row] else {return}
            contexto.delete(alunoSelecionado)
            do {
                try contexto.save()
            } catch {
                print(error.localizedDescription)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let alunoSelecionado = gerenciadorDeResultados?.fetchedObjects![indexPath.row] else { return }
        let newAluno = AlunoDaoViewController()
        newAluno.aluno = alunoSelecionado
        navigationController?.pushViewController(newAluno, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
            break
        default:
            tableView.reloadData()
        }
    }
    
}
