//
//  ViewController.swift
//  Mascotas
//
//  Created by Ángel González on 26/04/25.
//

import UIKit

class ViewController: UIViewController {
    var resumen: ResumenView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resumen = ResumenView(frame:view.bounds.insetBy(dx: 40, dy: 40))
        view.addSubview(resumen)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO: - Generar el resumen de la Base de Datos
        let info = DataManager.shared.resumenMascotas()
        resumen.tv.text = info
    }
}

