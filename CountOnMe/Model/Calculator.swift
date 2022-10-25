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

    func calculate(operation: [String]) -> Double {
        // Create local copy of operations
        var operationsToReduce = operation
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Double(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Double(operationsToReduce[2])!
            let result: Double
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "×": result = left * right
            case "÷": result = left / right
            default: fatalError("Unknown operator !")
            }
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        
//        if number.rounded(.up) == number.rounded(.down){
//            //number is integer
//        }else{
//            //number is not integer
//        }

        return Double(operationsToReduce[0])!
    }
}
