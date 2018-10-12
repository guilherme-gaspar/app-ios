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
    
    var gerenciadorDeResultados:NSFetchedResultsController<Aluno>?
    var contexto:NSManagedObjectContext {
        let appDelegate =  UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Registrar a celula personalizada para funcionar
        tableView.register(UINib.init(nibName: "DaoTableViewCell", bundle: nil), forCellReuseIdentifier: "CellDao")
        self.addBarItem()
        self.recuperaAlunos()
        self.title = "Dao Aluno"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        
        guard let aluno = gerenciadorDeResultados?.fetchedObjects![indexPath.row] else { return celula }
        
        celula.configuraCelula(aluno)
        
        return celula
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
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
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let alunoSelecionado = gerenciadorDeResultados?.fetchedObjects![indexPath.row] else { return }
        let newAluno = AlunoDaoViewController()
        newAluno.aluno = alunoSelecionado
        navigationController?.pushViewController(newAluno, animated: true)
        
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
