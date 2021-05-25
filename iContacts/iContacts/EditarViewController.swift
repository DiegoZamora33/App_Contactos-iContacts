//
//  EditarViewController.swift
//  iContacts
//
//  Created by Diego Zamora on 24/05/21.
//

import UIKit
import CoreData

class EditarViewController: UIViewController {
    
    // MARK: - Outlets y Variables Globales
    @IBOutlet weak var miNombre: UITextField!
    @IBOutlet weak var miTelefono: UITextField!
    @IBOutlet weak var miDireccion: UITextField!
    @IBOutlet weak var miFoto: UIImageView!
    @IBOutlet weak var miEmail: UITextField!
    
    var misContactos = [Contacto]()
    var miContacto: Contacto?
    var indice: Int?
    var flag = false
    
    /// Conexion al contexto
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    // MARK: - Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Cargar los Datos de mi CoreData
        loadCoreData()

        /// Renderizamos los datos del Contacto
        renderData()
        
        
        /// Preparamos la Gestura de la imagen
        let miGestura = UITapGestureRecognizer(target: self, action: #selector(clickImagen))
        
        miGestura.numberOfTapsRequired = 1
        miGestura.numberOfTouchesRequired = 1
        
        /// **  Agregamos la Gestura a la Foto
        miFoto.addGestureRecognizer(miGestura)
        miFoto.isUserInteractionEnabled = true
            
        
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
    
    // MARK: - Mis Funciones
    
    /// Funcion de la Gestura
    @objc func clickImagen(gestura: UIGestureRecognizer){
        
        /// Creamos un ViewController de la Galeria de Imagenes
        let miVC = UIImagePickerController()
        miVC.sourceType = .photoLibrary
        miVC.delegate = self
        miVC.allowsEditing = true
        
        /// Presentamos el ViewController
        present(miVC, animated: true, completion: nil)
    }
    
    /// Renderizar los datos de mi Contacto
    func renderData()
    {
        if miContacto != nil
        {
            miNombre.text = miContacto?.nombre
            miTelefono.text = "\(String(describing: miContacto!.telefono))"
            miDireccion.text = miContacto?.direccion
            
            
            if miContacto!.foto == nil{
                miFoto.image = UIImage(systemName: "person.circle")
            }
            else{
                miFoto.image = UIImage(data: miContacto!.foto!)
            }
        }
    }
    
    // MARK: - Touches Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // MARK: - Conexiones Action
    
    /// Boton para abrir la Camara
    @IBAction func btnCamara(_ sender: UIBarButtonItem) {
        /// Creamos un ViewController de la Galeria de Imagenes
        let miVC = UIImagePickerController()
        miVC.sourceType = .camera
        miVC.delegate = self
        miVC.allowsEditing = true
        
        /// Presentamos el ViewController
        present(miVC, animated: true, completion: nil)
    }
    
    /// Boton Cancelar
    @IBAction func btnCancelar(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    /// Boton Guardar
    @IBAction func btnGuardar(_ sender: UIButton) {
        if indice != nil{
            misContactos[indice!].setValue(miNombre.text, forKey: "nombre")
            misContactos[indice!].setValue(Int64(miTelefono.text!), forKey: "telefono")
            misContactos[indice!].setValue(miDireccion.text, forKey: "direccion")
            misContactos[indice!].setValue(miEmail.text, forKey: "email")
            
            if flag == true {
                misContactos[indice!].setValue(miFoto.image?.pngData(), forKey: "foto")
            }
            
            
            self.saveData()
            navigationController?.popToRootViewController(animated: true)
        }
    }
}


// MARK: - Extension para Delegados de Imagen y seleccionar Imagen
extension EditarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    /// Cuando el Usuario selecciona un Imagen
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        self.flag = true

        
        /// Ponemos mi Foto Seleccionada
        if let imagenSelected = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            self.miFoto.image = imagenSelected
        }
        
        /// Ocultamos el piker
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    /// Cuando el ussuario cancela la seleccion de imagen
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.flag = false
        picker.dismiss(animated: true, completion: nil)
    }
}
