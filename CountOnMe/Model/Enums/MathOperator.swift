//
//  MathOperator.swift
//  CountOnMe
//
//  Created by Canessane Poudja on 14/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum MathOperator: CaseIterable {
    case plus, minus, multiply, divide
    
    var symbol: String {
        switch self {
        case .divide: return "÷"
        case .minus: return "-"
        case .multiply: return "×"
        case .plus: return "+"
        }
    }
}
