//
//  Mascota+CoreDataClass.swift
//  Mascotas
//
//  Created by Ángel González on 26/04/25.
//
//

import Foundation
import CoreData

@objc(Mascota)
public class Mascota: NSManagedObject {
    
    func inicializa(_ mascotaVO:MascotaVO) {
        self.id = mascotaVO.id
        self.nombre = mascotaVO.nombre
        self.tipo = mascotaVO.tipo
        self.genero = mascotaVO.genero
        self.edad = mascotaVO.edad
    }
    
}
