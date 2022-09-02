//
//  String + extensions.swift
//  CountOnMe
//
//  Created by Thomas Heinis on 26/08/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import UIKit

extension String {

  func isPriorityOperator() -> Bool {
    if self == Operator.multiplication.rawValue || self == Operator.division.rawValue {
      return true
    }
    return false
  }
  
}
