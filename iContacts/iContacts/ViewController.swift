//
//  ViewController.swift
//  iContacts
//
//  Created by Diego Zamora on 16/05/21.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets y Variables
    @IBOutlet weak var miTabla: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Delegados de miTabla
        miTabla.delegate = self
        miTabla.dataSource = self
        
        /// REgistrar mi Celda Personalizada
        miTabla.register(UINib(nibName: "ContactoTableViewCell", bundle: nil), forCellReuseIdentifier: "miCeldaCustom")
    }


}

// MARK: - Extension para UITableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// Numero de Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    /// Render de cada Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// Mi celda Reutilizable
        let celda = miTabla.dequeueReusableCell(withIdentifier: "miCeldaCustom", for: indexPath) as! ContactoTableViewCell
        
        celda.nombre.text = "Nombre Contacto"
        celda.numero.text = "Telefono"
        
        return celda
    }
    
    
}
