import UIKit
import Alamofire

class DetailViewController: UIViewController {
    var laMascota: Mascota!
    var detalle: DetailView!
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.tintColor = .white
        detalle = DetailView(frame:view.bounds.insetBy(dx: 10, dy: 30))
        view.addSubview(detalle)
        // Configurar activity indicator
        activityIndicator.style = .large
        activityIndicator.color = .white
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        detalle.tintColor = .white
        detalle.txtNombre.text = laMascota.nombre ?? ""
        detalle.txtGenero.text = laMascota.genero ?? ""
        detalle.txtTipo.text = laMascota.tipo ?? ""
        detalle.txtEdad.text = "\(laMascota.edad)"
        detalle.btnDelete.addTarget(self, action: #selector(borrar), for: .touchUpInside)
        detalle.btnAdopt.addTarget(self, action: #selector(adoptar), for: .touchUpInside)
        
        // DEBUG: Verificar el ID de la mascota
        print("ID de la mascota: \(laMascota.id)")
        print("Nombre de la mascota: \(laMascota.nombre ?? "sin nombre")")
        // Cargar la imagen de la mascota
        cargarImagenMascota(id: Int(laMascota.id))
        actualizarVista()
    }
    
    @objc func adoptar() {
        let pickerVC = ResponsablePickerViewController()
        pickerVC.mascota = laMascota
        pickerVC.delegate = self
        present(pickerVC, animated: true)
    }
    
    @objc func borrar() {
        let ac = UIAlertController(title: "CONFIRMAR", message: "¿Borrar esta mascota?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Sí", style: .destructive) { _ in
            DataManager.shared.borrar(objeto: self.laMascota)
            self.dismiss(animated: true)
        })
        ac.addAction(UIAlertAction(title: "No", style: .cancel))
        present(ac, animated: true)
    }
    
    func actualizarVista() {
        if laMascota.responsable != nil {
            detalle.btnAdopt.isHidden = true
            let duenio = (laMascota.responsable?.nombre ?? "") + " " + (laMascota.responsable?.apellido_materno ?? "")
            detalle.lblDuenio.text = "Dueño: " + duenio
        }
        else {
            detalle.lblDuenio.text = ""
            detalle.btnAdopt.isHidden = false
        }
    }
    
    func cargarImagenMascota(id: Int) {
        // Primero verificar si la imagen ya existe localmente
        if let imagenLocal = cargarImagenLocal(id: id) {
            print("Imagen cargada desde el Library")
            detalle.foto.image = imagenLocal
            return
        }
        
        // Si no existe localmente, descargarla
        print("Se Descargo imagen desde internet...")
        activityIndicator.startAnimating()
        
        let urlString = "http://janzelaznog.com/DDAM/iOS/mascotas/\(id).png"
        guard let url = URL(string: urlString) else {
            print("Error: URL inválida")
            activityIndicator.stopAnimating()
            return
        }
        
        // Descargar la imagen con Alamofire
        AF.request(url, method: .get).response { response in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                if let data = response.data, let imagen = UIImage(data: data) {
                    // Mostrar la imagen
                    self.detalle.foto.image = imagen
                    
                    // Guardar la imagen en Library
                    self.guardarImagenLocal(imagen: imagen, id: id)
                    print("Imagen descargada y guardada en Library")
                } else {
                    print("Error al descargar la imagen")
                    // Mantener la imagen por defecto si falla
                }
            }
        }
    }

    func obtenerRutaImagenLocal(id: Int) -> URL? {
        // Obtener la carpeta Library
        guard let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        // Crear la ruta completa del archivo
        let archivoURL = libraryURL.appendingPathComponent("mascota_\(id).png")
        return archivoURL
    }

    func cargarImagenLocal(id: Int) -> UIImage? {
        guard let rutaArchivo = obtenerRutaImagenLocal(id: id) else {
            return nil
        }
        
        // Verificar si el archivo existe
        if FileManager.default.fileExists(atPath: rutaArchivo.path) {
            // Cargar la imagen desde el archivo
            if let data = try? Data(contentsOf: rutaArchivo),
               let imagen = UIImage(data: data) {
                return imagen
            }
        }
        
        return nil
    }

    func guardarImagenLocal(imagen: UIImage, id: Int) {
        guard let rutaArchivo = obtenerRutaImagenLocal(id: id) else {
            print("Error: No se pudo obtener la ruta de Library")
            return
        }
        
        // Convertir la imagen a datos PNG
        guard let datosImagen = imagen.pngData() else {
            print("Error: No se pudo convertir la imagen a PNG")
            return
        }
        
        // Guardar el archivo
        do {
            try datosImagen.write(to: rutaArchivo)
            print("Imagen guardada en: \(rutaArchivo.path)")
        } catch {
            print("Error al guardar la imagen: \(error)")
        }
    }

}
