//
//  Calculator.swift
//  CountOnMe
//
//  Created by Canessane Poudja on 14/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

class CalculatorImplementation: Calculator {

    // MARK: - INTERNAL

    // MARK: Properties

    weak var delegate: CalculatorDelegate?

    ///It is useful for checking textToCompute and result in unit tests
    let calculatorDelegateMock: CalculatorDelegateMock?

    // MARK: Methods

    init(cleaner: CleanerImplementation, calculatorDelegateMock: CalculatorDelegateMock? = nil) {
        self.calculatorDelegateMock = calculatorDelegateMock
        self.cleaner = cleaner
        self.cleaner.delegate = self
    }

    ///Appends a number to textToCompute and reset it if needed
    func add(number: Int) {
        if shouldResetTextToCompute { textToCompute = "" }
        textToCompute.append("\(number)")
    }

    ///Appends correctly a math operator to textToCompute if possible and reset it if needed
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

    ///Appends the result to textToCompute if there are no errors otherwise it throws it
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

            try assignValueForEachPartOfExpression(
                from: operationsToReduce,
                priorityOperatorIndex,
                &left,
                &mathOperator,
                &right)

            try performCalculation(left, mathOperator, right)

            replaceOperationByResult(in: &operationsToReduce, priorityOperatorIndex)
        }
        textToCompute.append(" = \(result)")
        shouldResetTextToCompute = true
    }

    // MARK: - PRIVATE

    // MARK: Properties

    private let cleaner: CleanerImplementation

    ///If it is true textToCompute is reset
    private var shouldResetTextToCompute = false

    ///Contains the expression
    private var textToCompute = "" {
        didSet {
            resetShouldResetTextToComputeIfNeeded()
            delegate?.didUpdateTextToCompute(text: textToCompute)
            calculatorDelegateMock?.didUpdateTextToCompute(text: textToCompute)
        }
    }

    ///Contains the result of the expression
    private var result: Float = 0 {
        didSet {
            calculatorDelegateMock?.didUpdateResult(number: result)
        }
    }

    ///It is equal to operationToReduce in order to verify if isDividingByZero
    private var elementsToReduce: [String] = []

    ///This array contains each element of the expression
    private var elements: [String] {
        textToCompute.split(separator: " ").map { "\($0)" }
    }

    ///Checks if the last element of the expression is a math operator
    private var expressionIsCorrect: Bool {
        elements.last != MathOperator.plus.symbol
            && elements.last != MathOperator.minus.symbol
            && elements.last != MathOperator.multiply.symbol
            && elements.last != MathOperator.divide.symbol
    }

    ///Checks if there is at least 3 elements in the expression
    private var expressionHasEnoughElement: Bool {
        elements.count >= 3
    }

    ///Checks if there is only a plus or minus sign in textToCompute
    private var textToComputeHasRelativeSign: Bool {
        textToCompute == MathOperator.plus.symbol || textToCompute == MathOperator.minus.symbol
    }

    ///Checks if the expression contains a division by 0
    private var isDividingByZero: Bool {
        guard let divideIndex = elementsToReduce.firstIndex(of: MathOperator.divide.symbol) else { return false }

        // Cast to Int because "00" != "0"
        guard Int(elementsToReduce[divideIndex + 1]) == 0 else { return false }

        return true
    }

    // MARK: Methods

    ///Returns true if the user is attempting to begin an expression with a multiply or division sign
    private func isStartingWithWrongOperator(mathOperator: MathOperator) -> Bool {
        return textToCompute.isEmpty && (mathOperator == MathOperator.multiply || mathOperator == MathOperator.divide)
    }

    ///Sets shouldResetTextToCompute to false if it is true
    private func resetShouldResetTextToComputeIfNeeded() {
        if shouldResetTextToCompute {
            shouldResetTextToCompute = false
        }
    }

    ///Throws an error if the expression is invalid
    private func verifyExpression() throws {
        guard expressionIsCorrect else {
            throw CalculatorError.expressionIsIncorrect
        }

        guard expressionHasEnoughElement else {
            throw CalculatorError.expressionIsIncomplete
        }
    }

    ///Returns the index of the first division or multiply sign if possible
    private func getPriorityOperatorIndex(in array: [String]) -> Int? {
        if let divideIndex = array.firstIndex(of: MathOperator.divide.symbol) {
            return divideIndex
        } else if let multiplyIndex = array.firstIndex(of: MathOperator.multiply.symbol) {
            return multiplyIndex
        }
        return nil
    }

    ///Tries to assign to left, mathOperator and right an element of the expression
    ///according to priorityOperatorIndex if there is one otherwise it throws an error
    private func assignValueForEachPartOfExpression(
        from array: [String],
        _ priorityOperatorIndex: Int?,
        _ left: inout Float,
        _ mathOperator:  inout String,
        _ right: inout Float
    ) throws {

        if let index = priorityOperatorIndex {
            guard let lhs = Float(array[index - 1]) else { throw CalculatorError.cannotAssignValue }
            guard let rhs = Float(array[index + 1]) else { throw CalculatorError.cannotAssignValue }

            left = lhs
            mathOperator = array[index]
            right = rhs
        } else {
            guard let lhs = Float(array[0]) else { throw CalculatorError.cannotAssignValue }
            guard let rhs = Float(array[2]) else { throw CalculatorError.cannotAssignValue }

            left = lhs
            mathOperator = array[1]
            right = rhs
        }
    }

    ///Tries to calculate result with right and left according to mathOperator otherwise it throws an error
    private func performCalculation(_ left: Float, _ mathOperator: String, _ right: Float) throws {
        switch mathOperator {
        case MathOperator.plus.symbol: result = left + right
        case MathOperator.minus.symbol: result = left - right
        case MathOperator.multiply.symbol: result = left * right
        case MathOperator.divide.symbol:
            if !isDividingByZero { result = left / right } else { throw CalculatorError.cannotDivideByZero }
        case "=": throw CalculatorError.equalSignFound
        default: throw CalculatorError.unknownOperatorFound
        }
    }

    ///Replace the operation which has just been carried out by its result in the given array
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

    ///Removes the 3 first elements of the given array and insert the result at the first index
    private func putResultAtFirst(of array: inout [String]) {
        array = Array(array.dropFirst(3))
        array.insert("\(result)", at: 0)
        elementsToReduce = array
    }
}

// MARK: - Extensions

extension CalculatorImplementation: CleanerDelegate {

    // MARK: - INTERNAL

    // MARK: Methods

    ///Clears totally textToCompute if shouldResetTextToCompute is true otherwise it removes only its last character
    func clearString() {
        if shouldResetTextToCompute {
            clearAllString()
        } else {
            textToCompute = cleaner.clear(textToCompute)
        }
    }

    ///Clears totally textToCompute
    func clearAllString() {
        textToCompute = cleaner.clearAll()
    }
}
