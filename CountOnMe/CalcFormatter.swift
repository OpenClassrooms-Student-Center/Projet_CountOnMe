//
//  CalcFormatter.swift
//  CountOnMe
//
//  Created by Laurent Debeaujon on 06/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//
import Foundation

class CalcFormatter {
    
    weak var delegate: CalcFormatterDelegate?
    
    private let figure = Figures()
    
    var numberFormatter: NumberFormatter
    
    private var storedResult: Bool
    
    private var formula = [String]()
    
    private var currentHistoryRow: Int = 0
    
    private var formulaRowQuantity: Int {
        return historyOfFormulas.count - 1
    }
    
    private var formulaCompleted: Bool {
        return formula.contains("=")
    }
    
    private var currentComma: String {
        return numberFormatter.decimalSeparator!
    }
    
    //array of all formula tapped and displayed in rows
    //regional settings applies (comma , thousand separator )
    private var historyOfFormulas = [[String]]()
    
    init() {
        self.storedResult = false
        formula.append("0")
        historyOfFormulas.append(formula)
        
        self.numberFormatter = NumberFormatter()
        self.numberFormatter.alwaysShowsDecimalSeparator = false
        self.numberFormatter.numberStyle = .decimal
        self.numberFormatter.maximumFractionDigits = 5
        self.numberFormatter.usesGroupingSeparator = true
    }
    
    ///function used when numeric button is tapped
    func addDigit(digitTxt: String) {
        
        storedResult = false
        
        var figure = digitTxt
        
        if let lastElement = formula.last,
            !isOperator(lastElement) {
            formula.removeLast()
            
            if lastElement == "0" {
                figure = digitTxt
            } else {
                figure = lastElement + figure
            }
        }
        formula.append(figure)
        delegate?.didRefreshHistoryResult(screen: historyResultFormatter())
    }
    
    ///function used when operator button is tapped (+,-,*,/)
    func addOperator(operatorChar: String) {
        if !canAddOperator(value: operatorChar) { return }
        
        //get the old result to use it for the next line
        //if operator is tapped first
        if storedResult && formula.last == "0" {
            guard let oldResult = figure.resultTxt else { return }
            resetFormula(defaultValue: oldResult)
        }
        
        formula.append(operatorChar)
        
        delegate?.didRefreshHistoryResult(screen: historyResultFormatter())
    }
    
    ///manage  formulas per row for history
    ///format each formula by using regional settings
    private func historyResultFormatter() -> String {
        var historyTxt: String = ""
        
        //delete the last row of formula for update
        if currentHistoryRow == formulaRowQuantity {
            historyOfFormulas.remove(at: currentHistoryRow)
        }
        
        //fix formula to be conform to regional settings
        let fixedFormula = fixFormula(formula: formula)
        
        //encode previous formulas lines with linefeeds
        historyOfFormulas.append(fixedFormula)
        if currentHistoryRow > 0 {
            for indexRow in 0...currentHistoryRow-1 {
                historyTxt += historyOfFormulas[indexRow].joined(separator: " ")
                historyTxt += "\n"
            }
        }
        //encode the current formula
        historyTxt += historyOfFormulas[currentHistoryRow].joined(separator: " ")
        return historyTxt
    }
    
    private func fixFormula(formula: [String]) -> [String] {
        var fixedFormula = [String]()
        var formulaElement: String
        for (index, value) in formula.enumerated() {
            formulaElement = value
            if formulaCompleted || index < formula.endIndex - 1 {
                if let fixedLastValue = convertToString(figure: value) {
                    formulaElement = fixedLastValue
                }
            }
            fixedFormula.append(formulaElement)
        }
        
        return fixedFormula
    }
    
    ///used when CE or C button are tapped
    func deleteElement(all: Bool) {
        if all == true {
            resetFormula(defaultValue: "0")
            
            historyOfFormulas.removeAll()
            currentHistoryRow = 0
            historyOfFormulas.append(formula)
        } else {
            formula.removeLast()
            if formula.count == 0 {
                formula.append("0")
            }
        }
        
        delegate?.didRefreshHistoryResult(screen: historyResultFormatter())
    }
    
    ///function used when +/- button is tapped
    func reverseFigure() {
        guard var figure = formula.last else { return }
        if !canAddOperator(value: figure) { return  }
        
        formula.removeLast()
        
        if figure.first == "-" {
            figure.removeFirst()
        } else {
            figure.insert("-", at: figure.startIndex)
        }
        formula.append(figure)
        
        delegate?.didRefreshHistoryResult(screen: historyResultFormatter())
    }
    
    ///function used when comma button is tapped
    func addComma() {
        guard var lastFigure = formula.last else { return }
        if !canAddOperator(value: lastFigure) { return }
        
        if !lastFigure.contains(currentComma) {
            lastFigure += currentComma
        }
        
        let index = formula.endIndex - 1
        formula[index] = lastFigure
        
        delegate?.didRefreshHistoryResult(screen: historyResultFormatter())
    }
    
    ///function used when Equal button is tapped
    func addEqual() {
        
        guard let result = figure.carryOutFormula(formula: formula, numberFormatter: numberFormatter) else {
            return
        }
        
        formula.append("=")
        formula.append(result)
        historyOfFormulas[currentHistoryRow].append(contentsOf: formula)
        storedResult = true
        
        delegate?.didRefreshHistoryResult(screen: historyResultFormatter())
        
        //init settings for a new row in history
        resetFormula(defaultValue: "0")
        currentHistoryRow += 1
        
    }
    
    private func resetFormula(defaultValue: String) {
        formula.removeAll()
        formula.append(defaultValue)
    }
    
    private func isOperator(_ value: String) -> Bool {
        if value == "+" || value == "-" || value == "/" || value == "x" || value == "=" {
            return true
        }
        return false
    }
    
    ///check if 2 consecutive operator have been tapped
    private func canAddOperator(value: String) -> Bool {
        if let lastValue = formula.last {
            if isOperator(value) && isOperator(lastValue) {
                return false
            }
        }
        return true
    }
    
    //apply regional settings to a figure into String
    private func convertToString(figure: String) -> String? {
        
        if let figureNumeric = numberFormatter.number(from: figure) {
            let fixedFigureNumeric = numberFormatter.string(from: figureNumeric)
            return fixedFigureNumeric
        }
        return nil
    }
}
