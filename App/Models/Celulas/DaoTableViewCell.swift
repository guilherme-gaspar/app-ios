//
//  DaoTableViewCell.swift
//  App
//
//  Created by user145557 on 10/3/18.
//  Copyright © 2018 user145557. All rights reserved.
//

import UIKit

class DaoTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var labelNomedoAluno: UILabel!
    @IBOutlet weak var imageAluno: UIImageView!
    
    // MARK: - Metodos
    
    func configuraCelula(_ aluno:Aluno) {
        labelNomedoAluno.text = aluno.nome
        imageAluno.layer.cornerRadius = imageAluno.frame.width / 2
        imageAluno.layer.masksToBounds = true
        if let imagemDoAluno = aluno.foto as? UIImage {
            imageAluno.image = imagemDoAluno
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
