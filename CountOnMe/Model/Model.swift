//
//  Model.swift
//  CountOnMe
//
//  Created by Elodie Desmoulin on 02/03/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation


class Model {
    var calculString: String = ""{
        didSet{
            NotificationCenter.default.post(name: Notification.Name("updateCalcul"), object: nil)
        }
    }
    var elements: [String] {
          return calculString.split(separator: " ").map { "\($0)" }
      }
    
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
    }
    
    func processCalcul(left: Int, operand: String, right: Int) -> String? {
        switch operand {
        case "+": return "\(left + right)"
        case "-": return "\(left - right)"
        case "*": return "\(left * right)"
        case "/": return "\(left / right)"
        default: return nil
        }
    }
}
