//
//  ContactoTableViewCell.swift
//  iContacts
//
//  Created by Diego Zamora on 18/05/21.
//

import UIKit

class ContactoTableViewCell: UITableViewCell {
    
    // MARK: - Outlets y Variables
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var numero: UILabel!
    @IBOutlet weak var foto: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
