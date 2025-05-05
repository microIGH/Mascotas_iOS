//
//  TableViewController.swift
//  Mascotas
//
//  Created by Ángel González on 26/04/25.
//

import UIKit

class TableViewController: UITableViewController {
    var mascotas = [Mascota]()
    let filtro = UISegmentedControl(items: ["Todos", "Gatos", "Perros", "Aves", "Otros"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filtro.selectedSegmentIndex = 0
        filtro.addTarget(self, action:#selector(actualizar), for:.valueChanged)
        tableView.tableHeaderView = filtro
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actualizar()
        NotificationCenter.default.addObserver(self, selector:#selector(actualizar), name: NSNotification.Name("DELETED_OBJECT"), object:nil)
    }
    
    @objc
    func actualizar() {
        // Considerar el valor seleccionado en el filtro
        switch filtro.selectedSegmentIndex {
            case 1:mascotas = DataManager.shared.todasLasMascotas(tipo: "gato")
            case 2:mascotas = DataManager.shared.todasLasMascotas(tipo:"perro")
            case 3:mascotas = // TODO: - Crea el método necesario
            case 4:mascotas = // TODO: - Crea el método necesario
            default:mascotas = DataManager.shared.todasLasMascotas()
        }
        tableView.reloadData()
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
        // Si decidimos no usar navigation controller:
        // dv.modalPresentationStyle = .automatic
        // self.present(dv, animated:true)
        self.navigationController?.pushViewController(dv, animated: true)
    }
}
