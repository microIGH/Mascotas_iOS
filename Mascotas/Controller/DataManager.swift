import Foundation
import CoreData

class DataManager : NSObject {
    static let shared = DataManager()
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Mascotas")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Database Setup
    func llenaBD() {
        let ud = UserDefaults.standard
        guard ud.integer(forKey: "BD-OK") != 1 else { return }
        
        let group = DispatchGroup()
        
        // Descargar Mascotas
        group.enter()
        descargaMascotas {
            group.leave()
        }
        
        // Descargar Responsables después de mascotas
        group.notify(queue: .main) {
            self.descargaResponsables()
            ud.set(1, forKey: "BD-OK")
        }
    }
    
    private func descargaMascotas(completion: @escaping () -> Void) {
        guard let url = URL(string: "http://janzelaznog.com/DDAM/iOS/mascotas.json") else {
            print("URL de mascotas inválida")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            defer { completion() }
            
            guard let data = data, error == nil else {
                print("Error descargando mascotas: \(error?.localizedDescription ?? "")")
                return
            }
            
            do {
                let mascotasVO = try JSONDecoder().decode([MascotaVO].self, from: data)
                print("Mascotas descargadas: \(mascotasVO.count)")
                self.guardaMascotas(mascotasVO)
            } catch {
                print("Error parseando mascotas: \(error)")
            }
        }.resume()
    }
    
    private func descargaResponsables() {
        guard let url = URL(string: "http://janzelaznog.com/DDAM/iOS/responsables.json") else {
            print("URL de responsables inválida")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error descargando responsables: \(error?.localizedDescription ?? "")")
                return
            }
            
            do {
                let responsablesVO = try JSONDecoder().decode([ResponsableVO].self, from: data)
                print("Responsables descargados: \(responsablesVO.count)")
                self.guardaResponsables(responsablesVO)
                
                // Verificar en Core Data
                DispatchQueue.main.async {
                    let responsables = self.todosLosResponsables()
                    print("Responsables en Core Data: \(responsables.count)")
                }
            } catch {
                print("Error parseando responsables: \(error)")
            }
        }.resume()
    }

    // MARK: - Core Data Operations
    func guardaMascotas(_ mascotas: [MascotaVO]) {
        let context = persistentContainer.viewContext
        context.perform {
            mascotas.forEach { vo in
                let mascota = Mascota(context: context)
                mascota.inicializa(vo)
            }
            self.saveContext()
        }
    }
    
    func guardaResponsables(_ responsables: [ResponsableVO]) {
        let context = persistentContainer.viewContext
        context.perform {
            responsables.forEach { vo in
                let responsable = Responsable(context: context)
                responsable.inicializa(vo)
                
                if let idMascota = vo.duenoDe, idMascota != 0 {
                    if let mascota = self.buscaMascotaConId(idMascota) {
                        responsable.addToMascotas(mascota)
                        mascota.responsable = responsable
                    }
                }
            }
            self.saveContext()
        }
    }
    
    // MARK: - Fetch Methods
    func buscaMascotaConId(_ idMascota: Int) -> Mascota? {
        let request = Mascota.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", idMascota)
        do {
            return try persistentContainer.viewContext.fetch(request).first
        } catch {
            print("Error buscando mascota: \(error)")
            return nil
        }
    }
    
    func todasLasMascotas() -> [Mascota] {
        let request = Mascota.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error fetch mascotas: \(error)")
            return []
        }
    }
    
    func todasLasMascotas(tipo: String) -> [Mascota] {
        let request = Mascota.fetchRequest()
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "tipo =[c] %@", tipo),
            NSPredicate(format: "tipo =[c] %@", "serpiente")
        ])
        
        do {
            let results = try persistentContainer.viewContext.fetch(request)
            return results.sorted { $0.nombre ?? "" > $1.nombre ?? "" }
        } catch {
            print("Error fetch mascotas por tipo: \(error)")
            return []
        }
    }
    
    func todosLosResponsables() -> [Responsable] {
        let request = Responsable.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error fetch responsables: \(error)")
            return []
        }
    }
    
    func resumenMascotas() -> String {
        var resumen = ""
        let context = persistentContainer.viewContext
        
        // Mascotas
        let countMascotas = (try? context.count(for: Mascota.fetchRequest())) ?? 0
        resumen += "Mascotas: \(countMascotas)\n"
        
        // Agrupación por tipo
        let keypathExp = NSExpression(forKeyPath: "id")
        let expression = NSExpression(forFunction: "count:", arguments: [keypathExp])
        
        let countDesc = NSExpressionDescription()
        countDesc.expression = expression
        countDesc.name = "cuantos"
        countDesc.expressionResultType = .integer64AttributeType
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Mascota")
        request.propertiesToFetch = ["tipo", countDesc]
        request.propertiesToGroupBy = ["tipo"]
        request.resultType = .dictionaryResultType
        
        do {
            let results = try context.fetch(request)
            results.forEach { dict in
                guard let d = dict as? [String: Any] else { return }
                resumen += "\(d["tipo"] ?? "?"): \(d["cuantos"] ?? 0)\n"
            }
        } catch {
            print("Error generando resumen: \(error)")
        }
        
        return resumen
    }
    
    func borrar(objeto: NSManagedObject) {
        persistentContainer.viewContext.delete(objeto)
        saveContext()
        NotificationCenter.default.post(name: NSNotification.Name("DELETED_OBJECT"), object: nil)
    }
}
