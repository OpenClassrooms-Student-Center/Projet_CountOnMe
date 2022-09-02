//
//  Expression.swift
//  CountOnMe
//
//  Created by Thomas Heinis on 18/08/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum Operator: String, CaseIterable {
  case addition = "+"
  case division = "/"
  case multiplication = "×"
  case substraction = "-"
}

final class Expression {
  // MARK: internal access properties

  var canAddOperator: Bool {
    for anOperator in Operator.allCases where anOperator.rawValue == elements.last {
      return false
    }
    return true
  }

  lazy var entered = defaultExpression

  var firstNumberIs0: Bool {
    if entered.first == defaultExpression.first {
      return true
    }
    return false
  }

  var hasEnoughElement: Bool {
    return elements.count >= 3
  }

  var hasResult: Bool {
    return entered.firstIndex(of: "=") != nil
  }

  var operationsToReduce: [String] {
    // Create local copy of operations
    var operationsToReduce = elements

    // Iterate over operations while an operand still here
    while operationsToReduce.count > 1 {
      let index = returnNextOperatorIndex(in: operationsToReduce)
      if let theOperator = Operator(rawValue: operationsToReduce[index]) {
        if let subresult = operate(with: theOperator, in: operationsToReduce, at: index) {
          if let cleanedSubresultString = subresult.cleanedString() {
            operationsToReduce.removeSubrange(index - 1...index + 1)
            operationsToReduce.insert(cleanedSubresultString, at: index - 1)
          }
        } else {
          return [String(Lexical.undefined)]
        }
      }
    }

    result = operationsToReduce.first ?? ""
    return operationsToReduce
  }

  lazy var result = defaultExpression

  // MARK: Private Access Properties

  private var defaultExpression: String = "0"

  private var elements: [String] {
    return entered.split(separator: " ").map { "\($0)" }
  }

  // MARK: Internal Access Methods

  convenience init(_ defaultExpression: String) {
    self.init()
    self.defaultExpression = defaultExpression
  }

  func addNumber(_ numberString: String) {
    if hasResult {
      allClear()
    }

    if firstNumberIs0 && canAddOperator {
      clear(forced: true)
    }

    entered.append(numberString)
  }

  func addOperator(_ theOperator: Operator) {
    if hasResult { // previous result becomes new expression
      entered = result
    }

    if !canAddOperator { // remove previous operator
      clear(forced: true)
    }

    if canAddOperator {
      entered.append(" " + theOperator.rawValue + " ")
    }
  }

  func allClear() { // to clear all expression
    entered = defaultExpression
  }

  func calculate() {
    guard checkErrors() else {
      return
    }

    if !hasResult {
      if let result = operationsToReduce.first {
        entered.append(" = \(result)")
      }
    }
  }

  func clear(forced: Bool = false) { // to clear only last element in expression
    if elements.count > 1 && canAddOperator || forced {
      let clearedElements = elements.dropLast(1)
      entered = clearedElements.joined(separator: " ")

      if !forced { // if next element isn't an operator
        entered.append(" ")
      }
    }
  }

  // MARK: Private Access Methods

  private func checkErrors() -> Bool {
    guard canAddOperator, hasEnoughElement else {
      sendNotification(for: .expressionMissOperand)
      return false
    }
    return true
  }

  private func operate(with theOperator: Operator, in operations: [String], at index: Int) -> Double? {
    // Defining both operands, indexed just before and after the operator
    let leftNumber = Double(operations[index - 1])
    let rightNumber = Double(operations[index + 1])
    // Declaring the expected result
    var result: Double? // result is nil by default

    // Checking the unwrapped Doubles, then making
    // the calculation switching to the given operator
    if let opA = leftNumber, let opB = rightNumber {
      switch theOperator {
      case .addition:
        result = opA + opB
      case .division:
        if opB != 0 {
          result = opA / opB
        }
      case .multiplication:
        result = opA * opB
      case .substraction:
        result = opA - opB
      }
    }
    return result
  }

  private func returnNextOperatorIndex(in elements: [String]) -> Int {
    for (index, element) in elements.enumerated() where element.isPriorityOperator() {
      return index
    }
    return 1 // this case if no priority operator is found
  }

  private func sendNotification(for error: Notification.ExpressionError) {
    let notificationName = error.notificationName
    let notification = Notification(name: notificationName, object: self, userInfo: ["name": error.notificationName])
    NotificationCenter.default.post(notification)
  }
}
