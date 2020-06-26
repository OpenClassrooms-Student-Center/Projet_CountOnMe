//
//  MathOperator.swift
//  CountOnMe
//
//  Created by Elodie Desmoulin on 13/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum MathOperator: CaseIterable {
    case minus, plus, multiply, divide

    var stringRepresentation: String {
        switch self {
        case .divide: return "/"
        case .minus: return "-"
        case .multiply: return "x"
        case .plus: return "+"
        }
    }
}
