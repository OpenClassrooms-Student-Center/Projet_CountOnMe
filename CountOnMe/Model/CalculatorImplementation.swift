//
//  Calculator.swift
//  CountOnMe
//
//  Created by Canessane Poudja on 14/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

class CalculatorImplementation: Calculator {
    
    var delegate: CalculatorDelegate?
    
    var textToCompute = "" {
        didSet {
            if expressionHaveResult {
                textToCompute = ""
            } else {
                delegate?.didUpdateTextToCompute(text: textToCompute)
            }
        }
    }

    func add(number: Int) {
        textToCompute.append("\(number)")
    }
    
    func add(mathOperator: MathOperator) {
        if textToCompute.isEmpty {
            textToCompute.append("\(mathOperator.symbol)")
        } else if canAddOperator {
            textToCompute.append(" \(mathOperator.symbol) ")
        } else {
            textToCompute = String(textToCompute.dropLast(3))
            textToCompute.append(" \(mathOperator.symbol) ")
        }
    }
    
    func calculate() -> Int? {
        guard expressionIsCorrect else {
            print("expression is not correct")
            return nil
        }
        
        guard expressionHaveEnoughElement else {
            print("expression has not enough element")
            return nil
        }
        
        //Create local copy of operations
        var operationsToReduce = elements
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            default: fatalError("Unknown operator !")
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        textToCompute.append("= ")
        return result
    }
    

    
    private var elements: [String] {
        return textToCompute.split(separator: " ").map { "\($0)" }
    }
    
    private var result = 0

    private var expressionHaveResult: Bool {
        return textToCompute.firstIndex(of: "=") != nil
    }
    
    // Error check computed variables
    private var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    private var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-"
    }
}


