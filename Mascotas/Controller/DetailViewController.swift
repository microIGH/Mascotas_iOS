//
//  ViewController.swift
//  Mascotas
//
//  Created by Ángel González on 26/04/25.
//

import UIKit

class DetailViewController: UIViewController {

    var laMascota : Mascota!
    var detalle: DetailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detalle = DetailView(frame:view.bounds.insetBy(dx: 40, dy: 40))
        view.addSubview(detalle)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO: - Obtener y presentar la información de la mascota
        
        // TODO: - Si la mascota ya tiene un responsable, ocultar el botón
    }


}

