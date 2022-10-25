//
//  Calculator.swift
//  CountOnMe
//
//  Created by Richard on 14/10/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.

import Foundation
import CoreImage

class Calculator {

    // Error check computed variables
    func theExpressionIsCorrect(elements: [String]) -> Bool {
        if elements.last != "+" && elements.last != "-" {
            return true
        }
        return false
    }

    func theExpressionHaveEnoughElement(elements: [String]) -> Bool {
        if elements.count >= 3 {
            return true
        }
        return false
    }

    func theExpressionCanAddOperator(elements: [String]) -> Bool {
        if elements.last != "+" && elements.last != "-" {
            return true
        }
        return false
    }

    func calculate(operation: [String]) -> String {
        // Create local copy of operations
        var operationsToReduce = operation
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Double(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Double(operationsToReduce[2])!
            var result: Double
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "×": result = left * right
            case "÷":
                if right == 0 {
                    return String("Erreur")
                } else {
                    result = left / right
                }
            default: fatalError("Unknown operator !")
            }
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            if result.rounded(.up) == result.rounded(.down) {
                // number is integer
                let resultInt = Int(result)
                operationsToReduce.insert("\(resultInt)", at: 0)
            } else {
                // number is not integer
                operationsToReduce.insert("\(result)", at: 0)
            }
        }
        return String(operationsToReduce[0])
    }
}
