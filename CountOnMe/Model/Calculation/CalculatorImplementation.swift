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
    let calculatorDelegateMock: CalculatorDelegateMock?
    
    init(cleaner: CleanerImplementation, calculatorDelegateMock: CalculatorDelegateMock? = nil) {
        self.calculatorDelegateMock = calculatorDelegateMock
        self.cleaner = cleaner
        self.cleaner.delegate = self
    }

    func add(number: Int) {
        if shouldResetTextToCompute { textToCompute = "" }
        textToCompute.append("\(number)")
    }
    
    func add(mathOperator: MathOperator) {
        if shouldResetTextToCompute { textToCompute = "" }
        if isStartingWithWrongOperator(mathOperator: mathOperator) {
            return
        } else if textToCompute.isEmpty {
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
    
    func calculate() throws {
        try verifyExpression()
        
        //Create local copy of operations
        var operationsToReduce = elements
        elementsToReduce = elements
        var priorityOperatorIndex: Int?
        var left: Float = 0
        var mathOperator = ""
        var right: Float = 0

        // Iterate over operations while an mathOperator still here
        while operationsToReduce.count > 1 {
            priorityOperatorIndex = getPriorityOperatorIndex(in: operationsToReduce)

            try assignValueForEachPartOfExpression(from: operationsToReduce, priorityOperatorIndex, &left, &mathOperator, &right)
            
            try performCalculation(left, mathOperator, right)

            replaceOperationByResult(in: &operationsToReduce, priorityOperatorIndex)
        }
        textToCompute.append(" = \(result)")
        shouldResetTextToCompute = true
    }

    private let cleaner: CleanerImplementation

    private var shouldResetTextToCompute = false

    private var textToCompute = "" {
        didSet {
            resetShouldResetTextToComputeIfNeeded()
            delegate?.didUpdateTextToCompute(text: textToCompute)
            calculatorDelegateMock?.didUpdateTextToCompute(text: textToCompute)
            print(textToCompute)
        }
    }

    private var result: Float = 0 {
        didSet {
            calculatorDelegateMock?.didUpdateResult(number: result)
        }
    }

    //Equals operationToReduce to verify if isDividingByZero
    private var elementsToReduce: [String] = []
    
    private var elements: [String] {
        return textToCompute.split(separator: " ").map { "\($0)" }
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

    private func isStartingWithWrongOperator(mathOperator: MathOperator) -> Bool {
        return textToCompute.isEmpty && (mathOperator == MathOperator.multiply || mathOperator == MathOperator.divide)
    }

    private var isDividingByZero: Bool {
        guard let divideIndex = elementsToReduce.firstIndex(of: MathOperator.divide.symbol) else { return false }

        // Cast to Int because "00" != "0"
        guard Int(elementsToReduce[divideIndex + 1]) == 0 else { return false }
        
        return true
    }

    private func resetShouldResetTextToComputeIfNeeded() {
        if shouldResetTextToCompute {
            shouldResetTextToCompute = false
        }
    }

    private func verifyExpression() throws {
        guard expressionIsCorrect else {
            throw CalculatorError.expressionIsIncorrect
        }

        guard expressionHasEnoughElement else {
            throw CalculatorError.expressionIsIncomplete
        }
    }

    private func getPriorityOperatorIndex(in array: [String]) -> Int? {
        if let multiplyIndex = array.firstIndex(of: MathOperator.multiply.symbol) {
            return multiplyIndex
        } else if let divideIndex = array.firstIndex(of: MathOperator.divide.symbol) {
            return divideIndex
        }
        return nil
    }

    private func assignValueForEachPartOfExpression(from array: [String], _ priorityOperatorIndex: Int?, _ left: inout Float, _ mathOperator:  inout String, _ right: inout Float) throws {
        if let index = priorityOperatorIndex {
            left = Float(array[index - 1])!
            mathOperator = array[index]
            right = Float(array[index + 1])!
        } else if priorityOperatorIndex == nil {
            left = Float(array[0])!
            mathOperator = array[1]
            right = Float(array[2])!
        } else {
            throw CalculatorError.cannotAssignValue
        }
    }

    private func performCalculation(_ left: Float, _ mathOperator: String, _ right: Float) throws {
        switch mathOperator {
        case MathOperator.plus.symbol: result = left + right
        case MathOperator.minus.symbol: result = left - right
        case MathOperator.multiply.symbol: result = left * right
        case MathOperator.divide.symbol: if !isDividingByZero { result = left / right } else { throw CalculatorError.cannotDivideByZero }
        default: throw CalculatorError.unknownOperatorFound
        }
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

extension CalculatorImplementation: CleanerDelegate {
    func clearString() {
        textToCompute = cleaner.clear(textToCompute)
    }
    
    func clearAllString() {
        textToCompute = cleaner.clearAll()
    }
}

