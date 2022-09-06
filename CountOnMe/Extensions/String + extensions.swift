//
//  String + extensions.swift
//  CountOnMe
//
//  Created by Thomas Heinis on 26/08/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

extension String {

  func cleanedString(with maxDigits: Int = 6) -> String? {
    if let numberDouble = Double(self) {
      let formatter = NumberFormatter()
      let number = NSNumber(value: numberDouble)
      formatter.minimumFractionDigits = 0
      formatter.maximumFractionDigits = maxDigits // maximum digits in Double after dot
      return formatter.string(from: number)
    }
    return Lexical.undefined
  }

  func isPriorityOperator() -> Bool {
    if self == Operator.multiplication.rawValue || self == Operator.division.rawValue {
      return true
    }
    return false
  }
  
}
