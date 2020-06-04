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
    private var operationsToReduce: [String] = []
    
    init() {
        self.result = 0.0
        self.calculationNumber = 0
       
    }
    
    private func lookingForPriorities() -> Int? {
        if let index = getDivisionIndex() { return index }
        if let index = getMultiplicationIndex() { return index }
        
        return 1
    }
    
    private func getMultiplicationIndex() -> Int? {
        return operationsToReduce.firstIndex(of: "x")
    }
    
    private func getDivisionIndex() -> Int? {
        return operationsToReduce.firstIndex(of: "/")
    }
    
    private func isDivisionByZero(rightValue: Double) -> Bool {
        if rightValue != 0 {
            return false
        }
        return true
    }
    
    private func carryOutOperation(_ operand: String, _ left: Double, _ right: Double) -> Bool {
        switch operand {
        case "+": result = left + right
        case "-": result = left - right
        case "x": result = left * right
        case "/":
            if !isDivisionByZero(rightValue: right) {
                result = left / right
            } else { return false }
        default: return false
        }
        return true
    }
    
    ///carry out the formula calculation in parameter and return the result as double type
    func carryOutFormula(formula: [String]) -> Double? {
        if formula.count < 3 { return nil }
        
        //fix formula out of the regional settings
        operationsToReduce = fixFormula(formula: formula)
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1,
            let calculationIndex = lookingForPriorities() {
            
            guard let left = Double(operationsToReduce[calculationIndex-1]) else { return nil }
            let operand = operationsToReduce[calculationIndex]
            guard let right = Double(operationsToReduce[calculationIndex+1]) else { return nil }
            
            if !carryOutOperation(operand, left, right) { return nil }
            
            //operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.removeSubrange(calculationIndex-1...calculationIndex+1)
            operationsToReduce.insert("\(result)", at: calculationIndex-1)
        }
        return round(result*100000)/100000
    }
    
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
