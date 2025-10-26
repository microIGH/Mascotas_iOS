import UIKit

class ViewController: UIViewController {
    var resumen: ResumenView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resumen = ResumenView(frame: view.bounds.insetBy(dx: 40, dy: 40))
        view.addSubview(resumen)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let info = DataManager.shared.resumenMascotas()
        resumen.tv.text = info
    }
}
