//
//  ErrorMessage.swift
//  CountOnMe
//
//  Created by Canessane Poudja on 17/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum ErrorMessage: CaseIterable {
    case notCorrect, notEnough
    
    var name: String {
        switch self {
        case .notCorrect: return "expression is not correct"
        case .notEnough: return "expression has not enough element"
        }
    }

    var message: String {
        switch self {
        case .notCorrect: return "The expression is not correct ! \nPlease enter a nuber after the operator."
        case .notEnough: return "The expression is not complete ! Please enter a number or an operator."
        }
    }

}
