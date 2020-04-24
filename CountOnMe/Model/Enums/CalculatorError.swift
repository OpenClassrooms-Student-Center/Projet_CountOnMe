//
//  CalculatorError.swift
//  CountOnMe
//
//  Created by Canessane Poudja on 21/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation


enum CalculatorError: Error {
    case expressionIsIncorrect
    case expressionIsIncomplete
    case cannotDivideByZero
    case cannotAssignValue
    case unknownOperatorFound
    
    
    var alertTitle: String {
        switch self {
        case .expressionIsIncorrect: return "Incorrect"
        case .expressionIsIncomplete: return "Incomplete"
        case .cannotDivideByZero: return "Dividing by 0"
        case .cannotAssignValue: return "Cannot assign value"
        case .unknownOperatorFound: return "Unknown operator"
        }
    }
    var alertMessage: String {
        switch self {
        case .expressionIsIncorrect: return "The expression is not correct ! \nPlease enter a number after the operator."
        case .expressionIsIncomplete: return "The expression is not complete ! Please enter a number or an operator."
        case .cannotDivideByZero: return "You are trying to divide by zero ! Please enter another number."
        case .cannotAssignValue: return "We cannot split the expression in 3 parts !"
        case .unknownOperatorFound: return "You have entered an unknown operator !"
        }
    }
    
}
