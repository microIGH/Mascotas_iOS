import UIKit
import CoreData

class TableViewController: UITableViewController {
    var mascotas = [Mascota]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lblTitulo = UILabel()
        lblTitulo.translatesAutoresizingMaskIntoConstraints = false
        lblTitulo.text = "Censo de Mascotas CDMX 2025"
        lblTitulo.font = UIFont.preferredFont(forTextStyle:.title3)
        lblTitulo.textColor = .cyan
        lblTitulo.shadowColor = .black
        lblTitulo.backgroundColor = .black
        lblTitulo.textAlignment = .center
        tableView.addSubview(lblTitulo)
        tableView.backgroundColor = .black
        tableView.separatorColor = .lightGray
        lblTitulo.topAnchor.constraint(equalTo:tableView.safeAreaLayoutGuide.topAnchor).isActive = true
        lblTitulo.leadingAnchor.constraint(equalTo:tableView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        lblTitulo.trailingAnchor.constraint(equalTo:tableView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        lblTitulo.heightAnchor.constraint(equalToConstant:40.0).isActive = true
        tableView.bringSubviewToFront(lblTitulo)
        tableView.topAnchor.constraint(equalTo: lblTitulo.bottomAnchor, constant:5.0).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actualizar()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(actualizar),
            name: NSNotification.Name("DELETED_OBJECT"),
            object: nil
        )
    }
    
    @objc func actualizar() {
        mascotas = DataManager.shared.todasLasMascotas()
        print("Mascotas cargadas: \(mascotas.count)")
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 68.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rv = ResumenView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:68))
        rv.tv.text = DataManager.shared.resumenMascotas()
        return rv
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mascotas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath)
        let m = mascotas[indexPath.row]
        cell.backgroundColor = .darkGray
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = m.nombre ?? "Sin nombre"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let m = mascotas[indexPath.row]
        let dv = DetailViewController()
        dv.laMascota = m
        dv.modalPresentationStyle = .automatic
        present(dv, animated: true)
        tableView.deselectRow(at: indexPath, animated:false)
    }
}
