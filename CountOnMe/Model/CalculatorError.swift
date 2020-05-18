//
//  CalculatorError.swift
//  CountOnMe
//
//  Created by Elodie Desmoulin on 12/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum CalculatorError: Error {
    case decimalIsAlreadyPresent
    case notAnOperator
    case anOperatorIsAlreadyPresent
    case expressionIsNotCorrect
    case numberIsMissing

    var title: String {
        switch self {
        case .decimalIsAlreadyPresent:
            return "Already a decimal"
        case .notAnOperator:
            return "Not an operator"
        case .anOperatorIsAlreadyPresent:
            return "Already an operator"
        case .expressionIsNotCorrect:
            return "Uncorrect Expression"
        case .numberIsMissing:
            return " Number is missing"
        }
    }

    var message: String {
        switch self {
        case .decimalIsAlreadyPresent:
            return "You are trying to add a decimal to a decimal..."
        case .notAnOperator:
            return "You are trying to add... What are you trying to add?"
        case .anOperatorIsAlreadyPresent:
           return"You have to add a number before trying to add another operator"
        case .expressionIsNotCorrect:
            return "This expression is not correct..."
        case .numberIsMissing:
            return "Add an number at first"
        }
    }
}
