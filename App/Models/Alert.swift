import Foundation
import UIKit

class Alert {
    
    let controller : UIViewController
    
    init(controller:UIViewController) {
        self.controller = controller
    }
    
    func showNaoTemAlunosApi(_ title:String = "Desculpa", message:String = "Nenhum aluno no servidor.") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil )
        alert.addAction(ok)
        controller.present(alert, animated: true, completion: nil)
    }
    
    func showDeslogado(_ title:String = "Desculpa", message:String = "Unexpected error.") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        controller.present(alert, animated: true, completion: nil)
    }
    
    func showDeslogar(_ title:String = "Sair da conta", message:String = "Voce tem certeza?") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Sim", style: UIAlertActionStyle.cancel, handler: nil)
        let nao = UIAlertAction(title: "Nao", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(nao)
        controller.present(alert, animated: true, completion: nil)
    }
    
}
