//
//  CalculatorError.swift
//  CountOnMe
//
//  Created by Elodie Desmoulin on 12/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum CalculatorErrors: Error {
    case decimalIsAlreadyPresent
    case notAnOperator
    case anOperatorIsAlreadyPresent
    case expressionIsNotCorrect
    case numberIsMissing
}

class CalculatorError {
    let calculatorErrors: CalculatorErrors
    var title: String = ""
    var message: String = ""

    init(calculatorErrors: CalculatorErrors) {
        self.calculatorErrors = calculatorErrors

            switch self.calculatorErrors {
            case .decimalIsAlreadyPresent:
                title = "Already a decimal"
                message = "You are trying to add a decimal to a decimal..."
            case .notAnOperator:
                title = "Not an operator"
                message = "You are trying to add... What are you trying to add?"
            case .anOperatorIsAlreadyPresent:
                title = "Already an operator"
                message = "You have to add an operand before trying to add another operator"
            case .expressionIsNotCorrect:
                title = "Uncorrect Expression"
                message = "This expression is not correct..."
            case .numberIsMissing:
                title = " Number is missing"
                message = "Add an operand at first"
            }
        }
}
