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
    
    private var output: String = ""
    
    private var elements: [String] {
        return output.split(separator: " ").map { "\($0)" }
    }
    
    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    private var expressionHaveResult: Bool {
        return output.firstIndex(of: "=") != nil
    }
    
    // MARK: - Methods
    
    func addNumber(_ input: String) -> String {
        if expressionHaveResult {
            output = ""
        }
        output.append(input)
        return output
    }
    
    func add() -> String {
        output.append(" + ")
        return output
    }
    
    func substract() -> String {
        output.append(" - ")
        return output
    }
    
    func equal() -> String {
        // Create local copy of operations
        var operationsToReduce = elements
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            
            let result: Int
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            default: fatalError("Unknown operator !")
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        output.append(" = \(operationsToReduce.first!)")
        return output
    }
}
