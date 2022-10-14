//
//  Calculator.swift
//  CountOnMe
//
//  Created by Cobra on 10/10/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

final class Calculator {

    // MARK: - Properties
    
    private var output: String = "0"
    private let operands: [String] = ["+", "-", "x", "÷"]
    
    private var elements: [String] {
        return output.split(separator: " ").map { "\($0)" }
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        // We know for sure that output is never empty, so neither are elements
        return !operands.contains(elements.last!)
    }
    
    private var expressionHaveResult: Bool {
        return output.firstIndex(of: "=") != nil
    }
    
    // MARK: - Methods
    
    // Allow operand change during operation and new operation with previous result
    private func addOperator(_ operand: String) -> String {
        if !canAddOperator {
            output.removeLast(3)
        } else if expressionHaveResult {
            output = elements.last!
        }
        output.append(operand)
        return output
    }
    
    func addNumber(_ input: String) -> String {
        if expressionHaveResult {
            output = ""
        }
        // Avoid several zeros in a row
        if input != "0" && output == "0" {
            output = input
        } else if (input == "0" && output != "0") || input != "0" {
            output.append(input)
        }
        return output
    }
    
    func add() -> String {
        addOperator(" + ")
    }
    
    func substract() -> String {
        addOperator(" - ")
    }
    
    func multiply() -> String {
        addOperator(" x ")
    }
    
    func divide() -> String {
        addOperator(" ÷ ")
    }
    
    func equal() -> String {
        // Apply only if there is not result already, there is enough elements and expression does not end with an operand
        if !expressionHaveResult && expressionHaveEnoughElement && canAddOperator {
            // Create local copy of operations
            var operationsToReduce = elements
            
            // Iterate over operations while an operand still here
            while operationsToReduce.count > 1 {
                let left = Double(operationsToReduce[0])!
                let operand = operationsToReduce[1]
                let right = Double(operationsToReduce[2])!
                
                let result: Double
                switch operand {
                case "+": result = left + right
                case "-": result = left - right
                case "x": result = left * right
                case "÷": result = left / right
                default: fatalError("Unknown operator !")
                }
                
                // Show integer number if decimal is 0
                var resultStr: String = "\(result)"
                if resultStr.hasSuffix(".0") {
                    resultStr = String(resultStr.dropLast(2))
                }
                
                operationsToReduce = Array(operationsToReduce.dropFirst(3))
                operationsToReduce.insert(resultStr, at: 0)
            }
            
            output.append(" = \(operationsToReduce.first!)")
        }
        return output
    }
    
    func allClear() -> String {
        output = "0"
        return output
    }
}
