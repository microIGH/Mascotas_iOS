//
//  MascotaVO.swift
//  Mascotas
//
//  Created by Ángel González on 26/04/25.
//

import Foundation

// MARK: - Element
struct MascotaVO: Codable {
    let id: Int16
    let nombre, tipo, genero: String
    let edad: Double
}

//typealias Empty = [MascotaVO]
