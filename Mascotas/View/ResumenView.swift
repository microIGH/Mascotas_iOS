import UIKit

class ResumenView: UIView {
    let tv = UITextView()
    
    override func draw(_ rect: CGRect) {
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = false
        tv.font = UIFont.systemFont(ofSize: 13)
        tv.backgroundColor = .systemCyan
        
        self.addSubview(tv)
        
        NSLayoutConstraint.activate([
            tv.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            tv.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            tv.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            tv.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
}
