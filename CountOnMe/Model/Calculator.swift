//
//  Model.swift
//  CountOnMe
//
//  Created by Elodie Desmoulin on 02/03/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Calculator {

    var operationStr: String = ""{
        didSet {
            NotificationCenter.default.post(name: Notification.Name("updateCalcul"), object: nil)
        }
    }

   private var elements: [String] {
          return operationStr.split(separator: " ").map { "\($0)" }
    }

    private var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
    }

    // Check if we have: Operand - Operator - Operand
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
           NotificationCenter.default.post(Notification(name: Notification.Name("error"), userInfo:
            ["message": "Vous ne pouvez pas mettre un opérateur sans un nombre avant !"]))
        }
        return false
    }

    private var divideByZero: Bool {
         return operationStr.contains("/ 0")
    }

    private var isDecimal: Bool {
        return elements.last?.firstIndex(of: ".") != nil
    }

    func addNumber(_ number: String) {
        if expressionHaveResult {
            operationStr = ""
    }
        operationStr.append(number)
    }

    func addDecimal() {
        if atLeastOneNumber {
            if !isDecimal {
            operationStr.append(".")
            } else {
                NotificationCenter.default.post(Notification(name: Notification.Name("error"),
                                                        userInfo: ["message": "Il s'agit déjà d'un décimal !"]))
            }
        } else {
            operationStr.append("0.")
        }
    }

    // MARK: - Operation

    func addOperator(_ element: String) {
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
                    NotificationCenter.default.post(Notification(name: Notification.Name("error"),
                    userInfo: ["message": "Ceci n'est pas un opérateur !"]))
                }
            } else {
                NotificationCenter.default.post(Notification(name: Notification.Name("error"),
                                                             userInfo: ["message": "Un operateur est déja mis !"]))
            }
        }
    }

    func reset() {
        operationStr = ""
    }

    private func result() {
        if expressionHaveResult {
           if let resultat = elements.last {
                   operationStr = resultat
            }
        }
    }

    func tappedEqual() {
        guard expressionIsCorrect else {
            return NotificationCenter.default.post(Notification(name: Notification.Name("error"),
                                                            userInfo: ["message": "Entrez une expression correcte !"]))
            }
        guard expressionHaveEnoughElement else {
            return  NotificationCenter.default.post(Notification(name: Notification.Name("error"),
                                                            userInfo: ["message": "Démarrez un nouveau calcul !!!"]))
        }
        guard !divideByZero else {
            return  NotificationCenter.default.post(Notification(name: Notification.Name("error"),
                                                            userInfo: ["message": "Impossible de diviser par 0 !"]))
        }
        operationPriority()
    }

    func operationPriority() {
        var operation = elements
        let prioritaryOperator = ["x", "/"]
        let regularOperator = ["+", "-"]
        var result = ""
        var operatorIndex: Int?

         while operation.count > 1 {
                    let firstIndexPriorityOperator = operation.firstIndex(where: {prioritaryOperator.contains($0)})
                    if let priorityOperatorIndex = firstIndexPriorityOperator {
                        operatorIndex = priorityOperatorIndex
                    } else {
                        let firstIndexOfOperation = operation.firstIndex(where: {regularOperator.contains($0)})
                        if let normalOperatorIndex = firstIndexOfOperation {
                            operatorIndex = normalOperatorIndex
                        }
                    }
                    if let index = operatorIndex {
                        let calculOperator = operation[index]
                        let left = Double(operation[index - 1])
                        let right = Double(operation[index + 1])
                        result = format(number: processCalcul(left: left!, right: right!, operand: calculOperator))
                        operation[index] = result
                        operation.remove(at: index + 1)
                        operation.remove(at: index - 1)
                    }
            }
                operationStr += " = \(operation[0])"
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

    func format(number: Double) -> String {
        let formater = NumberFormatter()
        formater.minimumFractionDigits = 0
        formater.maximumFractionDigits = 2
        guard let value = formater.string(from: NSNumber(value: number)) else { return ""}
        return value
    }
}
