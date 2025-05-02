//
//  Responsable+CoreDataClass.swift
//  Mascotas
//
//  Created by Ángel González on 26/04/25.
//
//

import Foundation
import CoreData

@objc(Responsable)
public class Responsable: NSManagedObject {
    
    func inicializa(_ responsableVO:ResponsableVO) {
        self.apellido_materno = responsableVO.apellidoMaterno
        self.apellido_paterno = responsableVO.apellidoPaterno
        self.ciudad = responsableVO.ciudad
        self.duenio_de = Int16((responsableVO.duenoDe ?? 0))
        self.email = responsableVO.email
        self.estado = responsableVO.estado
        self.nombre = responsableVO.nombre
        self.tel = responsableVO.tel
        self.mascotas = nil
    }
}
