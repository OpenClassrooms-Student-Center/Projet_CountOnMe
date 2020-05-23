//
//  ArithmetiqueUnit.swift
//  CountOnMe
//
//  Created by Laurent Debeaujon on 06/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//
import Foundation

class CalcFormater: CalcFormaterDelegateTest {
    
    weak var delegate: CalcFormaterDelegate?
    
    let figure = Figures()
    var formula: [String]
    
    private var formulaString: String {
        return formula.joined(separator: " ")
    }
    
    var screenResult: String {
        return formula.joined(separator: "\n")
    }
    
    init() {
        self.formula = ["0"]
    }
    
    func isOperator(_ value: String) -> Bool {
        if value == "+" || value == "-" || value == "/" || value == "*" || value == "%" {
            return true
        }
        return false
    }
    
    func addOperator(operatorChar: String) {
        if !getFormulaConsistency(value: operatorChar) {
            return
        }
        formula.append(operatorChar)
        delegate?.didRefreshScreenResult()
        
    }
    
    func addDigit(digitTxt: String) {
        if !getFormulaConsistency(value: digitTxt) {
            return
        }
        var figure = digitTxt
        if let lastElement = formula.last, Int(lastElement) != nil {
            formula.removeLast()
            if lastElement != "0" {
                figure = lastElement + figure
            }
        }
        formula.append(figure)
        delegate?.didRefreshScreenResult()
    }
    
    func deleteElement(all: Bool) {
        if all == true {
            formula.removeAll()
            formula.append("0")
        } else {
            formula.removeLast()
        }
        delegate?.didRefreshScreenResult()
    }
    
    func reverseFigure() {
        guard var figure = formula.last else { return }
        if !getFormulaConsistency(value: figure) {
            return
        }
        formula.removeLast()
        
        if figure.first == "-" {
            figure.removeFirst()
        } else {
            figure.insert("-", at: figure.startIndex)
        }
        
        formula.append(figure)
        
        delegate?.didRefreshScreenResult()
    }
    
    func addComma() {
        guard let lastFigure = formula.last else { return }
        if !getFormulaConsistency(value: lastFigure) {
            return
        }
        formula.removeLast()
        formula.append(lastFigure + figure.getCurrentSeparator)
        delegate?.didRefreshScreenResult()
    }
    
    func getResult() {
        var operationsToReduce = formula
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Double(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Double(operationsToReduce[2])!
            
            switch operand {
            case "+": figure.result = left + right
            case "-": figure.result = left - right
            case "*": figure.result = left * right
            case "/": figure.result = left / right
            case "%": figure.result = left / 100 * right
            default: fatalError("Unknown operator !")
            }
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(figure.result)", at: 0)
        }
        formula.append("=")
        
        if figure.hasIntegerResult {
            formatResultInInteger(result: figure.result)
            
        } else {
            formatResultInDouble(result: figure.result)
        }
        
        delegate?.didRefreshScreenResult()
    }
    func formatResultInDouble(result: Double) {
        let stringResult = figure.convertToString(figure: result, accuracy: 3)
        formula.append(stringResult)
        //formulaString.append("\n")
    }
    
    func formatResultInInteger(result: Double) {
        let stringResult = figure.convertToString(figure: result, accuracy: 0)
        formula.append(stringResult)
        //formulaString.append("\n")
    }
    
    ///check the consistency of the current formula
    func getFormulaConsistency(value: String) -> Bool {
        if formula.count > 0 {
            if let lastValue = formula.last {
                // check if 2 consecutive character have been tapped
                if isOperator(value) && isOperator(lastValue) {
                    return false
                }
            }
        }
        return true
    }
    
    func getCalcFormaterDisplay() -> String {
         
         if formulaString.count > 0 {
            var formulaResult = formula.filter { !$0.contains("\n") }
            guard let lastResultIndex = formulaResult.lastIndex(of: "=") else { return "" }
            let formulaIndexStart = formulaResult.index(lastResultIndex, offsetBy: -3)
            
            formulaResult = formulaResult.suffix(formulaIndexStart)
            
            return formulaResult.joined(separator: " ")
         }
         return ""
     }
}
