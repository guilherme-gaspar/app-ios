import UIKit
import Alamofire

class AlunoApi: NSObject {
    
    var alunoApi:Array<AlunoApiModel> = []
    
    
    func salvaAlunosNoServidor(parametros:Array<Dictionary<String, String>>) {
        guard let url = URL(string: "http://localhost:8080/api/aluno/lista") else { return }
        var requisicao = URLRequest(url: url)
        requisicao.httpMethod = "put"
        let json = try! JSONSerialization.data(withJSONObject: parametros, options: [])
        requisicao.httpBody = json
        requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
        Alamofire.request(requisicao)
    }
    
    func recuperaArray() -> Void {
        ApiTableViewController().alunos = alunoApi
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
                        self.alunoApi.append(aluno)
                    }
                    self.recuperaArray()
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
    
}

