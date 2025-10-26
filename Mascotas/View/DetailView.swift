import UIKit

class DetailView: UIView {
    let btnDelete = UIButton(type: .system)
    let txtNombre = UITextField()
    let txtTipo = UITextField()
    let txtGenero = UITextField()
    let txtEdad = UITextField()
    let btnAdopt = UIButton(type: .system)
    let lblDuenio = UILabel()
    var foto: UIImageView!

    
    override func draw(_ rect: CGRect) {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .black
        
        foto = UIImageView(image:UIImage(named: "mascotas"));
        foto.contentMode = .scaleAspectFit
        
        // Configurar campos
        let campos = [txtNombre, txtGenero, txtTipo, txtEdad]
        campos.forEach {
            $0.borderStyle = .roundedRect
            $0.isUserInteractionEnabled = false
            $0.heightAnchor.constraint(equalToConstant: 45).isActive = true
            
            $0.textColor = .white
            $0.backgroundColor = .darkGray
        }
        
        txtNombre.placeholder = "Nombre"
        txtGenero.placeholder = "Género"
        txtTipo.placeholder = "Tipo"
        txtEdad.placeholder = "Edad"
        
        // Botón Adoptar
        btnAdopt.setTitle("ADOPTAR", for: .normal)
        btnAdopt.backgroundColor = .systemBlue
        btnAdopt.setTitleColor(.white, for: .normal)
        btnAdopt.layer.cornerRadius = 10
        btnAdopt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btnAdopt.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Botón Eliminar
        btnDelete.setImage(UIImage(systemName: "trash"), for: .normal)
        btnDelete.tintColor = .red
        btnDelete.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        lblDuenio.font = UIFont.systemFont(ofSize: 14, weight:.bold)
        lblDuenio.textColor = .white
        // Añadir elementos
        stackView.addArrangedSubview(foto)
        campos.forEach { stackView.addArrangedSubview($0) }
        stackView.addArrangedSubview(lblDuenio)
        stackView.addArrangedSubview(btnAdopt)
        stackView.addArrangedSubview(btnDelete)
        
        self.addSubview(stackView)
        //Constraints
        NSLayoutConstraint.activate([
            foto.widthAnchor.constraint(equalToConstant: 120),
            foto.heightAnchor.constraint(equalToConstant: 120),
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            stackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8)
        ])
    }
}
