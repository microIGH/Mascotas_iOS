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
        // mascotas = DataManager.shared.todasLasMascotas()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mascotas.count
    }
    
    // TODO: - Implementar la presentación del nombre de la mascota
/*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
*/
    // TODO: - Implementar que despliegue la información de la mascota en DetailView
/*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
 */
}
