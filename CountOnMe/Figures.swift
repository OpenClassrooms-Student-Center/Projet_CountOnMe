//
//  Figures.swift
//  CountOnMe
//
//  Created by Laurent Debeaujon on 18/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Figures {
    
    private var result: Double
    
    var resultTxt: String?
    
    private var operationsToReduce: [String] = []
    
    init() {
        self.result = 0.0
    }
    
    //return the position of priority operators (x,/)
    private func lookingForPriorities() -> Int? {
        if let index = getDivisionIndex() { return index }
        if let index = getMultiplicationIndex() { return index }
        
        //index is 1 for no priority operator
        return 1
    }
    
    private func getMultiplicationIndex() -> Int? {
        return operationsToReduce.firstIndex(of: "x")
    }
    
    private func getDivisionIndex() -> Int? {
        return operationsToReduce.firstIndex(of: "/")
    }
    
    private func isDivisionByZero(rightValue: Double) -> Bool {
        if rightValue != 0 { return false }
        return true
    }
    
    //carry out calculations
    private func carryOutOperation(_ operand: String, _ left: Double, _ right: Double) -> Bool {
        switch operand {
        case "+": result = left + right
        case "-": result = left - right
        case "x": result = left * right
        case "/": if !isDivisionByZero(rightValue: right) {
            result = left / right
        } else {
            errorDivByZero()
            return false
            }
        default: return false
        }
        return true
    }
    
    ///carry out the formula calculation in parameter and return the result as double type
    func carryOutFormula(formula: [String], numberFormatter: NumberFormatter) -> String? {
        resultTxt = nil
        
        if (formula.count).isMultiple(of: 2) {
            errorFormula()
            return nil
        }
        //fix formula out of the regional settings
        operationsToReduce = formula
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1,
            let calculationIndex = lookingForPriorities() {
                
                guard let left = numberFormatter.number(from: operationsToReduce[calculationIndex-1])
                    else { return nil }
                let operand = operationsToReduce[calculationIndex]
                guard let right = numberFormatter.number(from: operationsToReduce[calculationIndex+1])
                    else { return nil }
                
                if !carryOutOperation(operand, left.doubleValue, right.doubleValue) { return nil }
                
                operationsToReduce.removeSubrange(calculationIndex-1...calculationIndex+1)
                
                resultTxt = numberFormatter.string(from: NSNumber(value: result))
                
                if let unpackedResult = resultTxt {
                    operationsToReduce.insert(unpackedResult, at: calculationIndex-1)
                }
        }
        return resultTxt
    }
}
