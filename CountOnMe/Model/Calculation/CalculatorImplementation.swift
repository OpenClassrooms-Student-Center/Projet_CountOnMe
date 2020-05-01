// swiftlint:disable vertical_whitespace
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



    // MARK: Methods

    ///Appends a number to textToCompute and reset it if needed
    func add(number: Int) {
        if shouldResetTextToCompute { textToCompute = "" }
        if number == 0 && isAddingUnnecessaryZero { return }
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
        operationsToReduce = elements

        // Iterate over operations while an mathOperator still here
        while operationsToReduce.count > 1 {
            let index = getOperatorIndex()
            try assignValueForEachPartOfExpression(with: index)
            try performCalculation()
            replaceOperationByResult(at: index)
        }
        textToCompute.append(" = \(formattedResult)")
        shouldResetTextToCompute = true
    }

    ///Clears totally textToCompute if shouldResetTextToCompute is true otherwise it removes only its last character
    func deleteLastElement() {
        if shouldResetTextToCompute {
            deleteAllElements()
        } else {
            textToCompute = cleaner.clearLastElement(of: textToCompute)
        }
    }

    ///Clears totally textToCompute
    func deleteAllElements() {
        textToCompute = cleaner.clearAll()
    }



    // MARK: - PRIVATE

    // MARK: Properties

    private let cleaner: Cleaner = CleanerImplementation()

    ///If it is true textToCompute is reset
    private var shouldResetTextToCompute = false

    ///Contains the expression
    private var textToCompute = "" {
        didSet {
            resetShouldResetTextToComputeIfNeeded()
            delegate?.didUpdateTextToCompute(text: textToCompute)
        }
    }

    ///This array contains each element of the expression
    private var elements: [String] {
        textToCompute.split(separator: " ").map { "\($0)" }
    }

    ///Equals to elements
    var operationsToReduce = [String]()

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

    private var isAddingUnnecessaryZero: Bool {
        textToCompute.isEmpty || textToComputeHasRelativeSign || textToCompute.last == " "
    }

    ///Checks if there is only a plus or minus sign in textToCompute
    private var textToComputeHasRelativeSign: Bool {
        textToCompute == MathOperator.plus.symbol || textToCompute == MathOperator.minus.symbol
    }

    ///If the expression is 1 + 2, left = 1
    private var left: Float = 0

    ///If the expression is 1 + 2, mathOperator = "+"
    private var mathOperator = ""

    ///If the expression is 1 + 2, right = 2
    private var right: Float = 0

    ///Contains the result of the expression
    private var result: Float = 0

    ///Returns result without .0 if it is a natural number
    private var formattedResult: String {
        NumberFormatter.localizedString(from: NSNumber(value: result), number: .decimal)
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
        guard expressionIsCorrect else { throw CalculatorError.expressionIsIncorrect }
        guard expressionHasEnoughElement else { throw CalculatorError.expressionIsIncomplete }
    }

    ///Returns the index of the first division or multiply sign if possible otherwise it returns 1
    private func getOperatorIndex() -> Int {
        var index = 1
        if let divideIndex = operationsToReduce.firstIndex(of: MathOperator.divide.symbol) {
            index = divideIndex
            return index
        } else if let multiplyIndex = operationsToReduce.firstIndex(of: MathOperator.multiply.symbol) {
            index = multiplyIndex
            return index
        }
        return index
    }

    ///Tries to assigns to left, mathOperator and right an element of the expression otherwise it throws an error
    private func assignValueForEachPartOfExpression(with index: Int) throws {
        guard
            let lhs = Float(operationsToReduce[index - 1]),
            let rhs = Float(operationsToReduce[index + 1])
            else { throw CalculatorError.cannotAssignValue }

        left = lhs
        mathOperator = operationsToReduce[index]
        right = rhs
    }

    ///Tries to calculate result with right and left according to mathOperator otherwise it throws an error
    private func performCalculation() throws {
        switch mathOperator {
        case MathOperator.plus.symbol: result = left + right
        case MathOperator.minus.symbol: result = left - right
        case MathOperator.multiply.symbol: result = left * right
        case MathOperator.divide.symbol: result = left / right
        case "=": throw CalculatorError.equalSignFound
        default: throw CalculatorError.unknownOperatorFound
        }
    }

    ///Replace the operation which has just been carried out by its result in the given array
    private func replaceOperationByResult(at index: Int) {
        for _ in 1...3 { operationsToReduce.remove(at: index - 1) }
        operationsToReduce.insert("\(result)", at: index - 1)
    }
}
