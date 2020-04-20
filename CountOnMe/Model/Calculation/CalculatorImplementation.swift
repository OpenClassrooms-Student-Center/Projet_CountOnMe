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
        } else if textToComputeHasRelativeSign {
            textToCompute = String(textToCompute.dropLast())
            textToCompute.append("\(mathOperator.symbol)")
        } else if expressionIsCorrect {
            textToCompute.append(" \(mathOperator.symbol) ")
        } else {
            textToCompute = String(textToCompute.dropLast(3))
            textToCompute.append(" \(mathOperator.symbol) ")
        }
    }
    
    func calculate() -> Float? {
        guard verifyExpression else { return nil }
        
        //Create local copy of operations
        var operationsToReduce = elements
        elementsToReduce = elements
        var priorityOperatorIndex: Int?
        var left: Float = 0
        var operand = ""
        var right: Float = 0
        var success = false

        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            priorityOperatorIndex = getPriorityOperatorIndex(in: operationsToReduce)
            assignValueForEachPartOfExpression(from: operationsToReduce, priorityOperatorIndex, &left, &operand, &right)
            success = canPerformCalculation(left, operand, right)
            replaceOperationByResult(in: &operationsToReduce, priorityOperatorIndex)
        }
        textToCompute.append("= ")
        if success { return result } else { return nil }
    }

    private var result: Float = 0

    //Equals operationToReduce to verify isDividingByZero
    private var elementsToReduce: [String] = []
    
    private var elements: [String] {
        return textToCompute.split(separator: " ").map { "\($0)" }
    }

    private var expressionHasResult: Bool {
        return textToCompute.firstIndex(of: "=") != nil
    }

    // Error check computed variables
    private var expressionIsCorrect: Bool {
        return elements.last != MathOperator.plus.symbol && elements.last != MathOperator.minus.symbol && elements.last != MathOperator.multiply.symbol && elements.last != MathOperator.divide.symbol
    }

    private var expressionHasEnoughElement: Bool {
        return elements.count >= 3
    }

    private var textToComputeHasRelativeSign: Bool {
        textToCompute == MathOperator.plus.symbol || textToCompute == MathOperator.minus.symbol
    }

    private var isDividingByZero: Bool {
        guard let divideIndex = elementsToReduce.firstIndex(of: MathOperator.divide.symbol) else { return false }

        // Cast to Int because "00" != "0"
        guard Int(elementsToReduce[divideIndex + 1]) == 0 else { return false }
        
        postNotification(ofName: ErrorMessage.divideByZero.rawValue)
        return true
    }

    private var verifyExpression: Bool {
        guard expressionIsCorrect else {
            postNotification(ofName: ErrorMessage.notCorrect.rawValue)
            return false
        }

        guard expressionHasEnoughElement else {
            postNotification(ofName: ErrorMessage.notEnough.rawValue)
            return false
        }
        return true
    }

    private func getPriorityOperatorIndex(in array: [String]) -> Int? {
        if let multiplyIndex = array.firstIndex(of: MathOperator.multiply.symbol) {
            return multiplyIndex
        } else if let divideIndex = array.firstIndex(of: MathOperator.divide.symbol) {
            return divideIndex
        }
        return nil
    }

    private func assignValueForEachPartOfExpression(from array: [String], _ priorityOperatorIndex: Int?, _ left: inout Float, _ operand:  inout String, _ right: inout Float) {
        if let index = priorityOperatorIndex {
            left = Float(array[index - 1])!
            operand = array[index]
            right = Float(array[index + 1])!
        } else {
            left = Float(array[0])!
            operand = array[1]
            right = Float(array[2])!
        }
    }

    private func canPerformCalculation(_ left: Float, _ operand: String, _ right: Float) -> Bool {
        switch operand {
        case MathOperator.plus.symbol: result = left + right
        case MathOperator.minus.symbol: result = left - right
        case MathOperator.multiply.symbol: result = left * right
        case MathOperator.divide.symbol: if !isDividingByZero { result = left / right } else { return false }
        default: postNotification(ofName: ErrorMessage.unknownOperator.rawValue)
        }
        return true
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

extension CalculatorImplementation {
    func clearTextToCompute() {
        textToCompute = String(textToCompute.dropLast())
    }
    
    func clearAllTextToCompute() {
        textToCompute = ""
    }
}

extension CalculatorImplementation {
    private func postNotification(ofName name: String) {
        let name = Notification.Name(name)
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
}


