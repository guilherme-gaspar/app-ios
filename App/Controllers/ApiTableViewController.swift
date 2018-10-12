//
//  ApiTableViewController.swift
//  App
//
//  Created by user145557 on 9/30/18.
//  Copyright © 2018 user145557. All rights reserved.
//

import UIKit
import Alamofire

class ApiTableViewController: UITableViewController {
    
    var alunos = Array<AlunoApiModel>()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
    override func viewDidLoad() {
        // Registrar a celula personalizada para funcionar
        tableView.register(UINib.init(nibName: "ApiTableViewCell", bundle: nil), forCellReuseIdentifier: "ApiCell")
        // Indicator View
        
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
        self.title = "Aluno Api"
        self.addBarItem()
        
        super.viewDidLoad()
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recuperaAlunosApi()
    }
    
    func recuperaAlunosApi() -> Void {
        activityIndicator.startAnimating()
        self.alunos = []
        recuperaAlunos {
            if self.alunos.count == 0 {
                let alert = UIAlertController(title: "Desculpa", message: "Nenhum usuario encontrado", preferredStyle: UIAlertControllerStyle.alert)
                
                let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                })
                
                let cadastro = UIAlertAction(title: "Cadastrar", style: UIAlertActionStyle.default, handler: { action in
                    self.addAlunoApi()
                })
                alert.addAction(cadastro)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }

    
    func addBarItem() -> Void {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAlunoApi))
        let sinc = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(sincAluno))
        navigationItem.rightBarButtonItems = [add, sinc]
        
    }
    
    @objc func sincAluno() -> Void {
        recuperaAlunosApi()
    }
    
    @objc func addAlunoApi() -> Void {
        let newAluno = AlunoApiViewController()
        navigationController?.pushViewController(newAluno, animated: true)
    }
    
    func recuperaAlunos(alunos  completion:@escaping() -> Void) {
        Alamofire.request("http://localhost:8080/api/aluno", method: .get).responseJSON { (response) in
            switch response.result {
            case .success:
                if let resposta = response.result.value as? Dictionary<String, Any> {
                    guard let listaDeAlunos = resposta["alunos"] as? Array<Dictionary<String, Any>> else { return }
                    
                    for dicionarioDeAluno in listaDeAlunos {
                        let aluno = AlunoApiModel()
                        aluno.nome = dicionarioDeAluno["nome"] as? String
                        aluno.endereco = dicionarioDeAluno["endereco"] as? String
                        aluno.telefone = dicionarioDeAluno["telefone"] as? String
                        aluno.site = dicionarioDeAluno["site"] as? String
                        let isEqual = self.alunos.contains(where: { (search) -> Bool in
                            if search.nome == aluno.nome {
                                return true
                            }
                            return false
                        })
                        if isEqual {
                            return
                        } else {
                            self.alunos.append(aluno)
                        }
                        
                        
                    }
                    completion()
                }
                break
            case .failure:
                print(response.error!)
                completion()
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alunos.count
    }
    
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "ApiCell", for: indexPath) as! ApiTableViewCell
        celula.tag = indexPath.row
        let aluno = alunos[indexPath.row]
        celula.configuraCelula(aluno)
        
        return celula
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
