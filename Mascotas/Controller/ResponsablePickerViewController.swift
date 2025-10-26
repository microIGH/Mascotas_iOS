import UIKit

class ResponsablePickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var responsables: [Responsable] = []
    var mascota: Mascota!
    weak var delegate: DetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Configurar PickerView
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        
        // Configurar UI
        let label = UILabel()
        label.text = "Selecciona un responsable:"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancelar", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelar), for: .touchUpInside)
        
        // StackView
        let stackView = UIStackView(arrangedSubviews: [label, picker, cancelButton])
        stackView.axis = .vertical
        stackView.spacing = 25
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // Constraints
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            picker.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        // Cargar datos
        responsables = DataManager.shared.todosLosResponsables()
        print(" Responsables disponibles: \(responsables.count)")
        picker.reloadAllComponents()
    }
    
    @objc func cancelar() {
        dismiss(animated: true)
    }
    
    // MARK: - PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return responsables.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let r = responsables[row]
        return "\(r.nombre ?? "") \(r.apellido_paterno ?? "")"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let responsable = responsables[row]
        mascota.responsable = responsable
        responsable.addToMascotas(mascota)
        DataManager.shared.saveContext()
        delegate?.actualizarVista()
        dismiss(animated: true)
    }
}
