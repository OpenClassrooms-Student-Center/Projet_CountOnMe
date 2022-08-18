//
//  Expression.swift
//  CountOnMe
//
//  Created by Thomas Heinis on 18/08/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

struct Expression {
  var entered = ""
  var elements: [String] {
    return entered.split(separator: " ").map { "\($0)" }
  }

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

  mutating func clear() {
    entered.removeAll()
  }
}
