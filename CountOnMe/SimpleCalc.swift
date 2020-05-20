//
//  ArithmetiqueUnit.swift
//  CountOnMe
//
//  Created by Laurent Debeaujon on 06/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//
import Foundation

class SimpleCalc {
    
    weak var delegate: SimpleCalcDelegate?
   
    let figure = Figures()
    
    var formulaString: [String] = []
    var screenResult: String {
           return formulaString.joined(separator: " ")
       }
    init() {
      
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
        formulaString.append(operatorChar)
        delegate?.didRefreshScreenResult()
        
    }
    
    func addDigit(digitTxt: String) {
        if !getFormulaConsistency(value: digitTxt) {
            return
        }
        var figure = digitTxt
        if let lastElement = formulaString.last, Int(lastElement) != nil {
              formulaString.removeLast()
            if lastElement != "0" {
                figure = lastElement + figure
            }
        }
        formulaString.append(figure)
        delegate?.didRefreshScreenResult()
    }
    
    func deleteElement(all: Bool) {
        if all == true {
            formulaString.removeAll()
            formulaString.append("0")
        } else {
            formulaString.removeLast()
        }
        delegate?.didRefreshScreenResult()
    }
    
    func reverseFigure() {
        guard var figure = formulaString.last else { return }
        if !getFormulaConsistency(value: figure) {
            return
        }
        formulaString.removeLast()
        
        if figure.first == "-" {
            figure.removeFirst()
        } else {
            figure.insert("-", at: figure.startIndex)
        }
        
        formulaString.append(figure)
        
        delegate?.didRefreshScreenResult()
    }
    
    func addComma() {
        guard let lastFigure = formulaString.last else { return }
        if !getFormulaConsistency(value: lastFigure) {
            return
        }
        formulaString.removeLast()
        formulaString.append(lastFigure + figure.getCurrentSeparator)
        delegate?.didRefreshScreenResult()
    }
        
    func getResult() {
        var operationsToReduce = formulaString.filter { !$0.contains("\n") }
        
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
        formulaString.append("=")
        
        if figure.hasIntegerResult {
            formatResultInInteger(result: figure.result)
            
        } else {
            formatResultInDouble(result: figure.result)
        }
        
        delegate?.didRefreshScreenResult()
    }
    func formatResultInDouble(result: Double) {
        let stringResult = figure.convertToString(figure: result, accuracy: 3)
        formulaString.append(stringResult)
        //formulaString.append("\n")
    }
    
    func formatResultInInteger(result: Double) {
        let stringResult = figure.convertToString(figure: result, accuracy: 0)
        formulaString.append(stringResult)
        //formulaString.append("\n")
    }
    
    ///check the consistency of the current formula
    func getFormulaConsistency(value: String) -> Bool {
        if formulaString.count > 0 {
            if let lastValue = formulaString.last {
                // check if 2 consecutive character have been tapped
                if isOperator(value) && isOperator(lastValue) {
                    return false
                }
            }
        }
        return true
    }
    
}
