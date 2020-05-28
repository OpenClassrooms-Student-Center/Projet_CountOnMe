//
//  ManageFigure.swift
//  CountOnMe
//
//  Created by Laurent Debeaujon on 18/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Figures {
    
    var result: Double = 0.0
    private var calculationNumber: Int
    
    var getCurrentSeparator: String {
        let numberFormatter = NumberFormatter()
        return numberFormatter.decimalSeparator
    }
    var hasIntegerResult: Bool {
        return result.truncatingRemainder(dividingBy: 1) == 0
    }
    init() {
        self.result = 0.0
        self.calculationNumber = 0
    }
    ///return a Double type
    
    func carryOutFormula(formula: [String]) -> String {
        var operationsToReduce = formula
        var roundedResult: String = ""
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Double(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Double(operationsToReduce[2])!
            
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "*": result = left * right
            case "/": result = left / right
            default: fatalError("Unknown operator !")
            }
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        if hasIntegerResult {
            roundedResult += formatResultInInteger(result: result)
            
        } else {
            roundedResult += formatResultInDouble(result: result)
        }
        return roundedResult
    }
}
