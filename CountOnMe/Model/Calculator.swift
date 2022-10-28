//
//  Calculator.swift
//  CountOnMe
//
//  Created by Richard on 14/10/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.

import Foundation
import CoreImage

final class Calculator {

    // Error check computed variables
    func theExpressionIsCorrect(elements: [String]) -> Bool {
        if elements.last != "+" && elements.last != "-" && elements.last != "×" && elements.last != "÷" {
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
        if elements.last != "+" && elements.last != "-" && elements.last != "×" && elements.last != "÷" {
            return true
        }
        return false
    }

    func theExpressionHaveResult(text: String) -> Bool {
        if text.firstIndex(of: "=") != nil {
            return true
        }
        return false
    }

    func calculate(operation: [String]) -> String {
        // Create local copy of operations
        var operationsToReduce = operation
        operationsToReduce = multiplicationAndDivision(operation: operation)
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Double(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Double(operationsToReduce[2])!
            var result: Double
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            default: return "Erreur"
            }
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            //            if result.rounded(.up) == result.rounded(.down) && result < 9999999 {
            //                // number is integer
            //                let resultInt = Int(result)
            //                operationsToReduce.insert("\(resultInt)", at: 0)
            //            } else {
            //                // number is not integer
            //                operationsToReduce.insert("\(result)", at: 0)
            //            }
            operationsToReduce = isAnIntAndInsert(result: result, operation: operationsToReduce, indexOfInsertion: 0)
        }
        return String(operationsToReduce[0])
    }

    private func multiplicationAndDivision(operation: [String]) -> [String] {
        var theOperation: [String] = operation

        guard let index = theOperation.firstIndex(where: { $0 == "×" || $0 == "÷" }) else {
            return operation
        }
        let left = Double(theOperation[index-1])!
        let operand = theOperation[index]
        let right = Double(theOperation[index+1])!
        var result: Double
        switch operand {
        case "×":
            result = left * right
        case "÷":
            if right == 0 {
                theOperation = ["Erreur"]
                return theOperation
            } else {
                result = left / right
            }
        default: return ["Erreur"]
        }
        theOperation.remove(at: index+1)
        theOperation.remove(at: index)
        theOperation.remove(at: index-1)
        theOperation = isAnIntAndInsert(result: result, operation: theOperation, indexOfInsertion: index-1)
        return multiplicationAndDivision(operation: theOperation)
    }

    private func isAnIntAndInsert(result: Double, operation: [String], indexOfInsertion: Int) -> [String] {
        var operationMutated = operation
        if result.rounded(.up) == result.rounded(.down) && result < 9999999 {
            // number is integer
            let resultInt = Int(result)
            operationMutated.insert("\(resultInt)", at: indexOfInsertion)
        } else {
            // number is not integer
            operationMutated.insert("\(result)", at: indexOfInsertion)
        }
        return operationMutated
    }
}
