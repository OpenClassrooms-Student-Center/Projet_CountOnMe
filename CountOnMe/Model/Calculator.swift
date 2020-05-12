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

    func displayText(operationStr: String) {
        delegate?.operationStringDidUpdate(operationStr)
    }

    var operationStr: String = "" {
        didSet {
            displayText(operationStr: operationStr)
        }
    }

    func addNumber(_ number: String) {
        if expressionHaveResult {
            operationStr = ""
        }
        operationStr.append(number)
    }

    func addDecimal() throws {
        if atLeastOneNumber {
            if !isDecimal {
                operationStr.append(".")
            } else {
                CalculatorErrors.decimalIsAlreadyPresent
            }
        } else {
            operationStr.append("0.")
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

    func addOperator(_ element: String) throws {
        result()
        if atLeastOneNumber {
            if canAddOperator {
                switch element {
                case "+":
                    operationStr.append(" + ")
                case "-":
                    operationStr.append(" - ")
                case "x":
                    operationStr.append(" x ")
                case "/":
                    operationStr.append(" / ")
                default:
                    CalculatorErrors.numberIsMissing
                }
            } else {
                CalculatorErrors.anOperatorIsAlreadyPresent
            }
        }
    }

    func reset() {
        operationStr = ""
    }

    func operationPriority(operation: [String]) -> Int? {
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

    func tappedEqual() throws {
        var operations = elements
        var result = ""
        if expressionIsCorrect && expressionHaveEnoughElement && !divideByZero && !expressionAlreadySolved {
            while operations.count > 1 {
                if let index = operationPriority(operation: operations) {
                    let calculOperator = operations[index]
                    guard let left = Double(operations[index - 1]) else {
                        CalculatorErrors.expressionIsNotCorrect
                        return }
                    guard let right = Double(operations[index + 1]) else {
                        CalculatorErrors.expressionIsNotCorrect
                        return }
                    result = format(number: processCalcul(left: left, right: right, operand: calculOperator))
                    operations[index] = result
                    operations.remove(at: index + 1)
                    operations.remove(at: index - 1)
                }
            }
            operationStr += " = \(operations[0])"
            delegate?.operationStringDidUpdate(result)
        } else {
            CalculatorErrors.expressionIsNotCorrect
            return
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

    private var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
    }

    private var expressionHaveResult: Bool {
        return operationStr.firstIndex(of: "=") != nil
    }

    private var atLeastOneNumber: Bool {
        if operationStr >= "0" {
            return elements.count >= 1
        } else {
            CalculatorErrors.numberIsMissing
        }
        return false
    }

    private var divideByZero: Bool {
        return operationStr.contains("/ 0")
    }

    private var isDecimal: Bool {
        return elements.last?.firstIndex(of: ".") != nil
    }

    private func result() {
        if expressionHaveResult {
            if let resultat = elements.last {
                operationStr = resultat
            }
        }
    }

    private func processCalcul(left: Double, right: Double, operand: String) -> Double {
        var result: Double = 0
        switch operand {
        case "+": result = left + right
        case "-": result = left - right
        case "x": result = left * right
        case "/": result = left / right
        default: break
        }
        return result
    }
}
