//
//  Calculation.swift
//  CountOnMe
//
//  Created by Thomas Heinis on 19/08/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

struct Calculation {
  private var operationsToReduce: [String]

  init (_ operationsToReduce: [String]) {
    self.operationsToReduce = operationsToReduce
  }

  mutating func operate() -> [String] {
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
}
