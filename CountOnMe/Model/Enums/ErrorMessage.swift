//
//  ErrorMessage.swift
//  CountOnMe
//
//  Created by Canessane Poudja on 17/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum ErrorMessage: String, CaseIterable {
    case notCorrect, notEnough, divideByZero, unknownOperator

    var message: String {
        switch self {
        case .notCorrect: return "The expression is not correct ! \nPlease enter a number after the operator."
        case .notEnough: return "The expression is not complete ! Please enter a number or an operator."
        case .divideByZero: return "You are trying to divide by zero ! Please enter another number."
        case .unknownOperator: return "You entered an unknown operator !"
        }
    }

}
