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
            if expressionHasResult {
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
        guard verifyExpression() else { return nil }
        
        //Create local copy of operations
        var operationsToReduce = elements
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            
            switch operand {
            case MathOperator.plus.symbol: result = left + right
            case MathOperator.minus.symbol: result = left - right
            default: fatalError("Unknown operator !")
            }
            
            putResultAtFirst(of: &operationsToReduce)
        }
        textToCompute.append("= ")
        return result
    }
    

    
    private var elements: [String] {
        return textToCompute.split(separator: " ").map { "\($0)" }
    }

    private var result = 0

    private var expressionHasResult: Bool {
        return textToCompute.firstIndex(of: "=") != nil
    }

    // Error check computed variables
    private var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-"
    }

    private var expressionHasEnoughElement: Bool {
        return elements.count >= 3
    }

    private var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-"
    }

    private func verifyExpression() -> Bool {
        guard expressionIsCorrect else {
            postNotification(ofName: ErrorMessage.notCorrect.name)
            return false
        }

        guard expressionHasEnoughElement else {
            postNotification(ofName: ErrorMessage.notEnough.name)
            return false
        }
        return true
    }

    private func postNotification(ofName name: String) {
        let name = Notification.Name(name)
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }

    private func putResultAtFirst(of array: inout [String]) {
        array = Array(array.dropFirst(3))
        array.insert("\(result)", at: 0)
    }
}


