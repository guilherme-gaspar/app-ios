import UIKit
import MessageUI

class Mensagem: NSObject, MFMessageComposeViewControllerDelegate {
    
    // MARK: - Metodos
    
    func configuraSMS(_ aluno:Aluno,_ controller:UIViewController) -> MFMessageComposeViewController? {
        if MFMessageComposeViewController.canSendText() {
            let componenteMensagem = MFMessageComposeViewController()
            guard let numeroDoAluno = aluno.telefone else { return componenteMensagem }
            componenteMensagem.recipients = [numeroDoAluno]
            componenteMensagem.messageComposeDelegate = self
            
            return componenteMensagem
        } else {
            let alert = UIAlertController(title: "Desculpa", message: "Voce nao esta em um iPhone", preferredStyle: UIAlertControllerStyle.alert)
            
            let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil )
            alert.addAction(ok)
            controller.present(alert, animated: true, completion: nil)
            return nil
        }
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
