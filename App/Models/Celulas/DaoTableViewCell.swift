//
//  DaoTableViewCell.swift
//  App
//
//  Created by user145557 on 10/3/18.
//  Copyright © 2018 user145557. All rights reserved.
//

import UIKit

class DaoTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var labelNomedoAluno: UILabel!
    
    func configuraCelula(_ aluno:Aluno) {
        labelNomedoAluno.text = aluno.nome
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
