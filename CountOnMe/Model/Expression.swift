//
//  Expression.swift
//  CountOnMe
//
//  Created by Thomas Heinis on 18/08/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

final class Expression {
  var elements: [String] {
    return entered.split(separator: " ").map { "\($0)" }
  }
  var entered = ""

  // Error check computed variables
  var isCorrect: Bool {
    return elements.last != "+" && elements.last != "-"
  }

  var haveEnoughElement: Bool {
    return elements.count >= 3
  }

  var canAddOperator: Bool {
    return elements.last != "+" && elements.last != "-"
  }

  var haveResult: Bool {
    return entered.firstIndex(of: "=") != nil
  }

  var operationsToReduce: [String] {
    // Create local copy of operations
    var operationsToReduce = elements

    // Iterate over operations while an operand still here
    while operationsToReduce.count > 1 {
      let left = Int(operationsToReduce[0])!
      let operand = operationsToReduce[1]
      let right = Int(operationsToReduce[2])!

      let result: Int
      switch operand {
      case "+": result = left + right
      case "-": result = left - right
      default: fatalError("Unknown operator !")
      }

      operationsToReduce = Array(operationsToReduce.dropFirst(3))
      operationsToReduce.insert("\(result)", at: 0)
    }
    return operationsToReduce
  }

  func clear() {
    entered.removeAll()
  }
}
