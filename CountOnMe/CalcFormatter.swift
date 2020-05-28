//
//  ArithmetiqueUnit.swift
//  CountOnMe
//
//  Created by Laurent Debeaujon on 06/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//
import Foundation

class CalcFormatter {
    
    weak var delegate: CalcFormatterDelegate?
    
    private let figure = Figures()
    private var formula = [String]()
    private var rowIndex: Int = 0
    private var activeOldResult: Bool
    private var screenRow = [String]()
    
    var screenResult: String = ""
    
    init() {
        self.activeOldResult = false
        self.rowIndex = addScreenRow()
    }
    
    func isOperator(_ value: String) -> Bool {
        if value == "+" || value == "-" || value == "/" || value == "*" {
            return true
        }
        return false
    }
    
    func addOperator(operatorChar: String) {
        if !getFormulaConsistency(value: operatorChar) {
            return
        }
        if activeOldResult,
            formula.count == 0 {
            let oldResult = figure.convertToString(figure: figure.result, accuracy: 5)
            formula.append(oldResult)
        }
        updateOutput(formulaElement: operatorChar)
    }
    
    func addDigit(digitTxt: String) {
        activeOldResult = false
        var figure = digitTxt
        if getFormulaConsistency(value: figure) {
            if let lastElement = formula.last, Int(lastElement) != nil {
                formula.removeLast()
                if lastElement != "0" {
                    figure = lastElement + figure
                }
            }
        }
        updateOutput(formulaElement: figure)
    }
    
    func updateOutput(formulaElement: String) {
        formula.append(formulaElement)
        screenResult = updateScreenRow()
        delegate?.didRefreshScreenResult(screen: screenResult)
    }
    
    func updateOutput() {
        screenResult = updateScreenRow()
        delegate?.didRefreshScreenResult(screen: screenResult)
    }
    
    func addScreenRow() -> Int {
        screenRow.append(formulaString())
        return screenRow.count - 1
    }
    
    func updateScreenRow() -> String {
        if screenRow.count < rowIndex - 1 {
            screenRow.append("0")
        }
        screenRow[rowIndex] = formulaString()
        return screenRow[rowIndex]
    }
    
    func screenString() -> String {
        return screenRow.joined(separator: "\n")
    }
    
    func formulaString() -> String {
        return formula.joined(separator: " ")
    }
    
    func deleteElement(all: Bool) {
        
        if all == true {
            screenRow.removeAll()
            initRow()
        } else {
            formula.removeLast()
            updateOutput()
        }
        
    }
    
    func initRow() {
        formula.removeAll()
        updateOutput(formulaElement: "0")
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
        print(formulaString())
        updateOutput(formulaElement: figure)
    }
    
    func addComma() {
        guard let lastFigure = formula.last else { return }
        if !getFormulaConsistency(value: lastFigure) { return }
        
        formula.removeLast()
        
        updateOutput(formulaElement: lastFigure + figure.getCurrentSeparator)
    }
    
    func getResult() {
        let result = figure.carryOutFormula(formula: formula)
        formula.append("=")
        updateOutput(formulaElement: result)
        rowIndex += 1
        activeOldResult = true
        initRow()
    }
    
    ///check the consistency of the current formula
    func getFormulaConsistency(value: String) -> Bool {
        if let lastValue = formula.last {
            // check if 2 consecutive character have been tapped
            if isOperator(value) && isOperator(lastValue) {
                return false
            }
        }
        return true
    }
    func formatResultInDouble(result: Double) -> String {
        let stringResult = convertToString(figure: Double, accuracy: 3)
        return stringResult
    }
    
    func formatResultInInteger(result: Double) -> String {
        let stringResult = convertToString(figure: result, accuracy: 0)
        return stringResult ?? ""
    }
    
    func convertToDouble(stringFigure: String) -> Double {
        let figure = Double(stringFigure)
        return figure ?? 0.0
    }
    
    ///format a figure with an accuracy of x digit after the comma.
    ///and return a String
    func convertToString(figure: Double, accuracy: Int) -> String? {
        //       String(format: "%."+String(accuracy)+"f", figure)
        NumberFormatter().accuracy = 
        return NumberFormatter().string(from: NSNumber(value: figure))
    }
    /*   // MARK: CalcFormatterDelegateTest
     func didScreenDisplayChanged() -> String {
     if formulaString.count > 0 {
     var formulaResult = formula.filter { !$0.contains("\n") }
     guard let lastResultIndex = formulaResult.lastIndex(of: "=") else { return "" }
     let formulaIndexStart = formulaResult.index(lastResultIndex, offsetBy: -3)
     
     formulaResult = formulaResult.suffix(formulaIndexStart)
     
     return formulaResult.joined(separator: " ")
     }
     return ""
     
     }*/
    
}
