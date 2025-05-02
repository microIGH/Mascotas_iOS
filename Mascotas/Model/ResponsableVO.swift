//
//  ResponsableVO.swift
//  Mascotas
//
//  Created by Ángel González on 26/04/25.
//

import Foundation

// MARK: - Element
struct ResponsableVO: Codable {
    let nombre, apellidoPaterno, apellidoMaterno, ciudad: String
    let estado, email, tel: String
    let duenoDe: Int?

    enum CodingKeys: String, CodingKey {
        case nombre
        case apellidoPaterno = "apellido_paterno"
        case apellidoMaterno = "apellido_materno"
        case ciudad, estado, email, tel
        case duenoDe = "dueno_de"
    }
}

//typealias Empty = [ResponsableVO]
