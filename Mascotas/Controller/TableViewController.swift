//
//  TableViewController.swift
//  Mascotas
//
//  Created by Ángel González on 26/04/25.
//

import UIKit

class TableViewController: UITableViewController {
    var mascotas = [Mascota]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: - Obtener todas las mascotas
        mascotas = DataManager.shared.todasLasMascotas(tipo:"gato")
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mascotas.count
    }
    
    // TODO: - Implementar la presentación del nombre de la mascota
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"reuseCell", for:indexPath)
        let m = mascotas[indexPath.row]
        cell.textLabel?.text = m.nombre ?? "una mascota"
        return cell
    }

    // TODO: - Implementar que despliegue la información de la mascota en DetailView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let m = mascotas[indexPath.row]
        let dv = DetailViewController()
        dv.laMascota = m
        dv.modalPresentationStyle = .automatic
        self.present(dv, animated:true)
    }
}
