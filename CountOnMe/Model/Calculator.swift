//
//  Model.swift
//  CountOnMe
//
//  Created by Elodie Desmoulin on 02/03/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

protocol CalculatorDelegate: class {
    func operationStringDidUpdate(_ operation: String)
}

class Calculator {

    weak var delegate: CalculatorDelegate?

    func updateText(operationStr: String) {
        delegate?.operationStringDidUpdate(operationStr)
    }

    var operationStr: String = "" {
        didSet {
            updateText(operationStr: operationStr)
        }
    }

    func addNumber(_ number: String) {
        if expressionHaveResult {
            operationStr = ""
        }
        operationStr.append(number)
    }

    func addDecimal() throws {

        guard !isDecimal else {
            throw CalculatorError.expressionIsNotCorrect
        }

        if isLastElementOperator || !hasAtLeastOneNumber {
            operationStr.append("0.")
        } else {
            operationStr.append(".")
        }
    }

    func format(number: Double) -> String {
        let formater = NumberFormatter()
        formater.minimumFractionDigits = 0
        formater.maximumFractionDigits = 2
        guard let value = formater.string(from: NSNumber(value: number)) else { return ""}
        return value
    }

    // MARK: Operation

    func addOperator(_ mathOperator: MathOperator) throws {
        updateOperationStrWithResult()

        guard hasAtLeastOneNumber else {
            throw CalculatorError.numberIsMissing
        }

        guard !isLastElementOperator else {
             throw CalculatorError.anOperatorIsAlreadyPresent
        }

        operationStr.append(" \(mathOperator.stringRepresentation) ")
    }

    func reset() {
        operationStr = ""
    }

    func checkOperationPriority(operation: [String]) -> Int? {
        let prioritaryOperator = ["x", "/"]
        let regularOperator = ["+", "-"]
        var operatorIndex: Int?

        let firstIndexPriorityOperator = operation.firstIndex(where: {prioritaryOperator.contains($0)})
        if let priorityOperatorIndex = firstIndexPriorityOperator {
            operatorIndex = priorityOperatorIndex
        } else {
            let firstIndexOfOperation = operation.firstIndex(where: {regularOperator.contains($0)})
            if let normalOperatorIndex = firstIndexOfOperation {
                operatorIndex = normalOperatorIndex
            }
        }
        return operatorIndex
    }

    func resolveOperation() throws {
        var operations = elements
        var result = ""
        if expressionIsCorrect && expressionHaveEnoughElement && !isDivideByZero && !expressionAlreadySolved {
            while operations.count > 1 {
                if let index = checkOperationPriority(operation: operations) {
                    let calculOperator = operations[index]
                    guard let left = Double(operations[index - 1]) else {
                        throw CalculatorError.expressionIsNotCorrect
                         }
                    guard let right = Double(operations[index + 1]) else {
                        throw CalculatorError.expressionIsNotCorrect
                         }
                    result = format(number: processCalcul(left: left, right: right, mathOperator: calculOperator))
                    operations[index] = result
                    operations.remove(at: index + 1)
                    operations.remove(at: index - 1)
                }
            }
            operationStr += " = \(operations[0])"
            delegate?.operationStringDidUpdate(result)
        } else {
            throw CalculatorError.expressionIsNotCorrect
        }
    }

    // MARK: - Private

    private var elements: [String] {
        return operationStr.split(separator: " ").map { "\($0)" }
    }

    private var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
    }

    private var expressionAlreadySolved: Bool {
        return operationStr.contains("=")
    }

    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }

    private var isLastElementOperator: Bool {
        return elements.last == "+" || elements.last == "-" || elements.last == "x" || elements.last == "/"
    }

    private var expressionHaveResult: Bool {
        return operationStr.firstIndex(of: "=") != nil
    }

    private var hasAtLeastOneNumber: Bool {
        return elements.count > 0
    }

    private var isDivideByZero: Bool {
        return operationStr.contains("/ 0")
    }

    private var isDecimal: Bool {
        return elements.last?.firstIndex(of: ".") != nil
    }

    private func updateOperationStrWithResult() {
        if expressionHaveResult {
            if let resultat = elements.last {
                operationStr = resultat
            }
        }
    }

    private func processCalcul(left: Double, right: Double, mathOperator: String) -> Double {
        var result: Double = 0
        switch mathOperator {
        case "+": result = left + right
        case "-": result = left - right
        case "x": result = left * right
        case "/": result = left / right
        default: break
        }
        return result
    }
}
