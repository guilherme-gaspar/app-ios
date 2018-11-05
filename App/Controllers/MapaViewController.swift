
import UIKit
import MapKit

class MapaViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var mapa: MKMapView!
    
    // MARK: - Variaveis
    
    var aluno:Aluno?
    
    // MARK: - Metodos
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = getTitulo()
        localizacaoInicial()
        localizarAluno()
    }
    
    func getTitulo() -> String {
        return "Localizar Alunos"
    }
    
    func localizacaoInicial() {
        Localizacao().converteEnderecoEmCoordenadas(endereco: "Ulbra Canoas - Rio Grande do Sul") { (localizacaoEncontrada) in
            let pino = self.configuraPino(titulo: "Ulbra Canoas", localizacao: localizacaoEncontrada)
            let regiao = MKCoordinateRegionMakeWithDistance(pino.coordinate, 5000, 5000)
            self.mapa.setRegion(regiao, animated: true)
            self.mapa.addAnnotation(pino)
        }
    }
    
    func localizarAluno() {
        if let aluno = aluno {
            Localizacao().converteEnderecoEmCoordenadas(endereco: aluno.endereco!, local: { (localizacaoEncontrada) in
                let pino = self.configuraPino(titulo: aluno.nome!, localizacao: localizacaoEncontrada)
                self.mapa.addAnnotation(pino)
            })
        }
    }
    
    func configuraPino(titulo:String, localizacao:CLPlacemark) -> MKPointAnnotation {
        let pino = MKPointAnnotation()
        pino.title = titulo
        pino.coordinate = localizacao.location!.coordinate
        
        return pino
    }
    
    
    
    
}
