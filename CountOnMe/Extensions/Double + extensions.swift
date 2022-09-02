//
//  Double + extensions.swift
//  CountOnMe
//
//  Created by Thomas Heinis on 28/08/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

extension Double {

  func cleanedString(with maxDigits: Int = 6) -> String? {
    let formatter = NumberFormatter()
    let number = NSNumber(value: self)
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = maxDigits // maximum digits in Double after dot
    return formatter.string(from: number)
  }

}
