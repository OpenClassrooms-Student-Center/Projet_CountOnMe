//
//  Notification + extension.swift
//  CountOnMe
//
//  Created by Thomas Heinis on 02/09/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

extension Notification {

  enum ExpressionError: String {
    case operandMissing = "There is no operand to finish the expression."

    var notificationName: Notification.Name {
      return Notification.Name(rawValue: "\(self)")
    }

    var notificationMessage: String {
      return self.rawValue
    }
  }

}
