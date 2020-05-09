//
//  ArithmetiqueUnit.swift
//  CountOnMe
//
//  Created by Laurent Debeaujon on 06/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

class ArithmeticUnit {
    var elements: [String] {
          return textView.text.split(separator: " ").map { "\($0)" }
      }
    // Error check computed variables
      var expressionIsCorrect: Bool {
          return elements.last != "+" && elements.last != "-"
      }
      
      var expressionHaveEnoughElement: Bool {
          return elements.count >= 3
      }
      var canAddOperator: Bool {
             return elements.last != "+" && elements.last != "-"
         }
     var expressionHaveResult: Bool {
           return textView.text.firstIndex(of: "=") != nil
       }
       
