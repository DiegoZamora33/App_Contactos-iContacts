//
//  ViewController.swift
//  iContacts
//
//  Created by Diego Zamora on 16/05/21.
//

import UIKit
import CoreData
import MessageUI

class ViewController: UIViewController {
    
    // MARK: - Outlets y Variables
    @IBOutlet weak var miTabla: UITableView!
    var misContactos = [Contacto]()
    var contactoSelected: Contacto?
    var miIndice: Int?
    
    /// Conexion al contexto
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Cargar los Datos de mi CoreData
        loadCoreData()
        miTabla.reloadData() 
        
        /// Delegados de miTabla
        miTabla.delegate = self
        miTabla.dataSource = self
        
        /// Registrar mi Celda Personalizada
        miTabla.register(UINib(nibName: "ContactoTableViewCell", bundle: nil), forCellReuseIdentifier: "miCeldaCustom")
    }
    
    
    // MARK: - Will Apear
    override func viewWillAppear(_ animated: Bool) {
        self.loadCoreData()
        self.miTabla.reloadData()
    }
    
    // MARK: - Load CoreData
    func loadCoreData() {
        let fetchRequest : NSFetchRequest<Contacto> = Contacto.fetchRequest()
        
        do{
            misContactos = try contexto.fetch(fetchRequest)
        }
        catch {
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
    // MARK: - Save Data
    func saveData() {
        do{
            try self.contexto.save()
        }
        catch let error as NSError{
            print("Error: \(error.localizedDescription)")
        }
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
            
            let direccion = ""
            
            /// Apend Contacto Nuevo
            let newContacto = Contacto(context: self.contexto)
            newContacto.nombre = nombre
            newContacto.telefono = telefono
            newContacto.direccion = direccion
            
            self.misContactos.append(newContacto)
            
            
            /// Save Data
            self.saveData()
            
            
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
            nombre.autocapitalizationType = UITextAutocapitalizationType.words
        }
        
        alert.addTextField { (telefono: UITextField) in
            telefono.placeholder = "Telefono"
            telefono.keyboardType = .numberPad
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
        celda.numero.text = " 📞 \(String(describing: self.misContactos[indexPath.row].telefono))"
        
        if self.misContactos[indexPath.row].foto == nil{
            celda.foto.image = UIImage(systemName: "person.circle")
        }
        else{
            celda.foto.image = UIImage(data: self.misContactos[indexPath.row].foto!)
        }
        
        
        return celda
    }
    
    /// Height por cada Row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 78
    }
    
    
    /// Select una Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        miTabla.deselectRow(at: indexPath, animated: true)
        
        /// Elegimos el contacto seleccionado
        contactoSelected = misContactos[indexPath.row]
        miIndice = indexPath.row
        
        performSegue(withIdentifier: "Editar", sender: self)
    }
    
    
    /// Override Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Editar"
        {
            let editarVC = segue.destination as! EditarViewController
            
            /// Mandamos mi Contacto
            editarVC.miContacto = contactoSelected
            editarVC.indice = miIndice
        }
    }
    
    
    /// Swipe Actions
    /// ** Para Borrar
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        /// Creamos mis Acciones
        let accionBorrar = UIContextualAction(style: .normal, title: "Eliminar") { (_, _, _) in
            /// Eliminamos de CoreData y del Arreglo
            
            
            let alert = UIAlertController(title: "Eliminar a \(String(describing: self.misContactos[indexPath.row].nombre!))", message: "Desea Eliminar este Contacto?", preferredStyle: .actionSheet)
            
            /// Creamos mis acciones
            let actionOK = UIAlertAction(title: "Eliminar", style: .destructive) {
                (_) in
                
                self.contexto.delete(self.misContactos[indexPath.row])
                self.misContactos.remove(at: indexPath.row)
                self.saveData()
                self.miTabla.reloadData()
            }
            
            let actionCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            /// Agregamos acciones a la Alerta
            alert.addAction(actionOK)
            alert.addAction(actionCancel)
            
            
            /// Presentamos mi Alerta
            self.present(alert, animated: true, completion: nil)
            
        }
        
        accionBorrar.image = UIImage(systemName: "trash")
        accionBorrar.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [accionBorrar])
    }
    
    /// ** Para LLamar y Mensaje
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        /// Creamos mis Acciones
        /// Para llamar
        let accionLlamar = UIContextualAction(style: .normal, title: "Llamar") { (_, _, _) in
            if let phoneCallURL = URL(string: "TEL://+52\(self.misContactos[indexPath.row].telefono)") {

                let application:UIApplication = UIApplication.shared

                if (application.canOpenURL(phoneCallURL)) {

                    application.open(phoneCallURL, options: [:], completionHandler: nil)

                }

            }
        }
        
        accionLlamar.image = UIImage(systemName: "phone")
        accionLlamar.backgroundColor = .systemTeal
        
        /// Para Mensaje
        let accionMensaje = UIContextualAction(style: .normal, title: "Mensaje") { (_, _, _) in
            
            if self.misContactos[indexPath.row].email != nil{
            
                if !MFMailComposeViewController.canSendMail() {
                    print("Mail services are not available")
                    let alert = UIAlertController(title: "Error al enviar email", message: "Necesitas iniciar sesion en la app de correo", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
                
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self
                
                // Configure the fields of the interface.
                composeVC.setToRecipients(["\(self.misContactos[indexPath.row].email!)"])
                composeVC.setSubject("Hola \(self.misContactos[indexPath.row].nombre!.uppercased())")
                composeVC.setMessageBody("Querid@ \(self.misContactos[indexPath.row].nombre!.capitalized)... \n", isHTML: false)
                
                
                // Present the view controller modally.
                self.present(composeVC, animated: true, completion: nil)
            
            }
            else
            {
                let alert = UIAlertController(title: "Este Contacto no tiene un Email establecido", message: "Desea establece un email para este Contacto?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: .default){_ in
                    /// Elegimos el contacto seleccionado
                    self.contactoSelected = self.misContactos[indexPath.row]
                    self.miIndice = indexPath.row
                    
                    self.performSegue(withIdentifier: "Editar", sender: self)
                })
                alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
                self.present(alert, animated: true)
            }
            
            
        }
        
        accionMensaje.image = UIImage(systemName: "message")
        accionMensaje.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [accionLlamar,accionMensaje])
    }
}


//MARK:- Extension Delegate Methods MFMailCompose
extension ViewController: MFMailComposeViewControllerDelegate {
 
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error {
            //show error alert
            controller.dismiss(animated: true)
            return
        }
        
        
        switch result {
        case .cancelled:
            print("Cancelado")
            showAlert(msj: "Cancelled")
        case .failed:
            print("Error al enviar msj")
            showAlert(msj: "Error to send msj")
        case .saved:
            print("Guardado en borradores!")
            showAlert(msj: "Saved ind drafts")
        case .sent:
            print("Correo enviado!")
            showAlert(msj: "email sent")
        default:
            print("error desconocido")
            showAlert(msj: "uknown error")
        }
        
        controller.dismiss(animated: true)
    }
    func showAlert(msj: String) {
        let alert = UIAlertController(title: "Notificacion", message: msj, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: msj, style: .default, handler: nil))
        present(alert, animated: true)
        
    }
}
