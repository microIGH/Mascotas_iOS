//
//  Mascota+CoreDataProperties.swift
//  Mascotas
//
//  Created by Ángel González on 26/04/25.
//
//

import UIKit
import Foundation
import CoreData


extension Mascota {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mascota> {
        return NSFetchRequest<Mascota>(entityName: "Mascota")
    }

    @NSManaged public var edad: Double
    @NSManaged public var genero: String?
    @NSManaged public var id: Int16
    @NSManaged public var nombre: String?
    @NSManaged public var tipo: String?
    @NSManaged public var responsable: Responsable?

}

extension Mascota : Identifiable {

}

