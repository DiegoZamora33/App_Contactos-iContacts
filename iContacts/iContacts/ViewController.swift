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
    var misContactos = [Contacto]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Delegados de miTabla
        miTabla.delegate = self
        miTabla.dataSource = self
        
        /// REgistrar mi Celda Personalizada
        miTabla.register(UINib(nibName: "ContactoTableViewCell", bundle: nil), forCellReuseIdentifier: "miCeldaCustom")
    }
    
    // MARK: - Agregar nuevo Contacto
    @IBAction func addContacto(_ sender: UIBarButtonItem) {
        
        /// Creamos mi Alerta
        let alert = UIAlertController(title: "Nuevo Contacto", message: "Llena los siguientes campos", preferredStyle: .alert)
        
        /// Creamos mis acciones
        let actionOK = UIAlertAction(title: "Guardar", style: .default) {
            (_) in
            
            /// Get Nombre
            guard let nombre = alert.textFields?.first?.text else {return}
            
            /// Get Telefono
            guard let telefono = Int64((alert.textFields?.last?.text ?? nil)!) else {return}
            
            /// Apend Contacto Nuevo
            self.misContactos.append(Contacto(nombre: nombre, telefono: telefono, direccion: "HERE"))
            
            /// Reload Data
            self.miTabla.reloadData()
        }
        
        let actionCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        /// Agregamos acciones a la Alerta
        alert.addAction(actionOK)
        alert.addAction(actionCancel)
        
        /// Agregamos los TextField
        alert.addTextField { (nombre: UITextField) in
            nombre.placeholder = "Nombre"
        }
        
        alert.addTextField { (nombre: UITextField) in
            nombre.placeholder = "Telefono"
        }
        
        
        /// Presentamos mi Alerta
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Extension para UITableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// Numero de Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return misContactos.count
    }
    
    /// Render de cada Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// Mi celda Reutilizable
        let celda = miTabla.dequeueReusableCell(withIdentifier: "miCeldaCustom", for: indexPath) as! ContactoTableViewCell
        
        celda.nombre.text = self.misContactos[indexPath.row].nombre
        celda.numero.text = " 📞 \(String(describing: self.misContactos[indexPath.row].telefono!))"
        
        return celda
    }
    
    /// Height por cada Row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 78
    }
}
