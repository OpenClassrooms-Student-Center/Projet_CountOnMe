//
//  Figures.swift
//  CountOnMe
//
//  Created by Laurent Debeaujon on 18/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Figures {
    
    var result: Double
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
        } else { return false }
        default: return false
        }
        return true
    }
    
    ///carry out the formula calculation in parameter and return the result as double type
    func carryOutFormula(formula: [String]) -> Double? {
        
        //fix formula out of the regional settings
        operationsToReduce = fixFormula(formula: formula)
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1,
            let calculationIndex = lookingForPriorities() {
                
                guard let left = Double(operationsToReduce[calculationIndex-1]) else { return nil }
                let operand = operationsToReduce[calculationIndex]
                guard let right = Double(operationsToReduce[calculationIndex+1]) else { return nil }
                
                if !carryOutOperation(operand, left, right) { return nil }
                
                operationsToReduce.removeSubrange(calculationIndex-1...calculationIndex+1)
                operationsToReduce.insert("\(result)", at: calculationIndex-1)
        }
        
        //round the result to 5 digits after comma
        return round(result*100000)/100000
    }
    
    //fix dot as comma  to be compatible to calculation
    private func fixFormula(formula: [String]) -> [String] {
        let numberFormatter = NumberFormatter()
        let decimal = numberFormatter.decimalSeparator!
        var fixedFormula = [String]()
        for value in formula {
            let fixedValue = value.replacingOccurrences(of: decimal, with: ".")
            fixedFormula.append(fixedValue)
        }
        return fixedFormula
    }
}
