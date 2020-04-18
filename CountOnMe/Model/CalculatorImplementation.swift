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
    
    func calculate() -> Double? {
        guard verifyExpression() else { return nil }
        
        //Create local copy of operations
        var operationsToReduce = elements
        elementsToReduce = operationsToReduce
        var priorityOperatorIndex: Int?
        var left: Double
        var operand: String
        var right: Double

        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            priorityOperatorIndex = getPriorityOperatorIndex(in: operationsToReduce)

            if let index = priorityOperatorIndex {
                left = Double(operationsToReduce[index - 1])!
                operand = operationsToReduce[index]
                right = Double(operationsToReduce[index + 1])!
            } else {
                left = Double(operationsToReduce[0])!
                operand = operationsToReduce[1]
                right = Double(operationsToReduce[2])!
            }

            switch operand {
            case MathOperator.plus.symbol: result = left + right
            case MathOperator.minus.symbol: result = left - right
            case MathOperator.multiply.symbol: result = left * right
            case MathOperator.divide.symbol: if canDivide { result = left / right } else { return nil }
            default: fatalError("Unknown operator !")
            }

            replaceOperationByResult(in: &operationsToReduce, priorityOperatorIndex)
        }
        textToCompute.append("= ")
        return result
    }
    

    
    private var elements: [String] {
        return textToCompute.split(separator: " ").map { "\($0)" }
    }

    private var elementsToReduce: [String] = []

    private var result: Double = 0

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

    private var isDividingByZero: Bool {
        guard let divideIndex = elementsToReduce.firstIndex(of: MathOperator.divide.symbol) else { return false }

        guard elementsToReduce[divideIndex + 1] == "0" else {
            return false
        }

        return true
    }

    private var canDivide: Bool {
        guard !isDividingByZero else {
            postNotification(ofName: ErrorMessage.divideByZero.name)
            return false
        }
        return true
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

    private func getPriorityOperatorIndex(in array: [String]) -> Int? {
        if let multiplyIndex = array.firstIndex(of: MathOperator.multiply.symbol) {
            return multiplyIndex
        } else if let divideIndex = array.firstIndex(of: MathOperator.divide.symbol) {
            return divideIndex
        }
        return nil
    }

    private func replaceOperationByResult(in array: inout [String], _ priorityOperatorIndex: Int? ) {
        if var index = priorityOperatorIndex {
            index -= 1

            for _ in 1...3 {
                array.remove(at: index)
            }

            array.insert("\(result)", at: index)
            elementsToReduce = array
        } else {
            putResultAtFirst(of: &array)
        }
    }

    private func putResultAtFirst(of array: inout [String]) {
        array = Array(array.dropFirst(3))
        array.insert("\(result)", at: 0)
        elementsToReduce = array
    }
}


