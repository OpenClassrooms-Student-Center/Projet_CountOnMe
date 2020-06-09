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

    private var storedResult: Bool

    private var formula = [String]()

    private var currentHistoryRow: Int = 0

    var formulaRowQuantity: Int {
           return historyOfFormulas.count - 1
    }
    
    private var formulaCompleted: Bool {
        return formula.contains("=")
    }
    
    private var getComma: String {
        let numberFormatter = NumberFormatter()
        return numberFormatter.decimalSeparator
    }
    
    //array of all formula tapped and displayed in rows
    //regional settings applies (comma , thousand separator )
    private var historyOfFormulas = [[String]]()
    
    init() {
        self.storedResult = false
        resetFormula(defaultValue: "0")
        resetHistory()
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
        delegate?.didRefreshScreenResult(screen: historyResultFormatter())
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
        
        delegate?.didRefreshScreenResult(screen: historyResultFormatter())
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
    
    func fixFormula(formula: [String]) -> [String] {
        var fixedFormula = [String]()
        var formulaElement: String
        for (index, value) in formula.enumerated() {
            formulaElement = value
            if formulaCompleted || index < formula.endIndex - 1 {
                if let fixedLastValue = convertToString(figure: value, accuracy: 5, thousandSeparator: true) {
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
            resetHistory()
        } else {
            formula.removeLast()
            if formula.count == 0 {
                formula.append("0")
            }
        }
        
        delegate?.didRefreshScreenResult(screen: historyResultFormatter())
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
        
        delegate?.didRefreshScreenResult(screen: historyResultFormatter())
    }
    
    ///function used when comma button is tapped
    func addComma() {
        guard var lastFigure = formula.last else { return }
        if !canAddOperator(value: lastFigure) { return }
        
        if !lastFigure.contains(getComma) {
            lastFigure += getComma
        }
        
        let index = formula.endIndex - 1
        formula[index] = lastFigure
        
        delegate?.didRefreshScreenResult(screen: historyResultFormatter())
    }
    
    ///function used when Equal button is tapped
    func addEqual() {
        
        guard let result = figure.carryOutFormula(formula: formula) else {
            errorNotification()
            return
        }
        
        formula.append("=")
        formula.append(result)
        historyOfFormulas[currentHistoryRow].append(contentsOf: formula)
        storedResult = true
        
        delegate?.didRefreshScreenResult(screen: historyResultFormatter())
        
        //init settings for a new row in history
        resetFormula(defaultValue: "0")
        currentHistoryRow += 1
        
    }
    
    private func resetFormula(defaultValue: String) {
        formula.removeAll()
        formula.append(defaultValue)
    }
    
    private func resetHistory() {
        historyOfFormulas.removeAll()
        currentHistoryRow = 0
        historyOfFormulas.append(formula)
    }
    
    private func isOperator(_ value: String) -> Bool {
        if value == "+" || value == "-" || value == "/" || value == "x" || value == "=" {
            return true
        }
        return false
    }
    
    private func isInteger(valueTxt: String) -> Bool {
        return Int(valueTxt) != nil
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
  
    //convert a figure from a string
    private func convertToString(figure: String, accuracy: Int = 0,
                                 thousandSeparator: Bool = false) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.alwaysShowsDecimalSeparator = false
        
        if accuracy != 0 || thousandSeparator {
            numberFormatter.alwaysShowsDecimalSeparator = true
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = accuracy
        }
        numberFormatter.usesGroupingSeparator = thousandSeparator
        if let figureNumeric = numberFormatter.number(from: figure) {
            var fixedFigureNumeric = numberFormatter.string(from: figureNumeric)
            if let figureTxt = fixedFigureNumeric,
                figureTxt.last == numberFormatter.decimalSeparator.last {
                fixedFigureNumeric!.removeLast()
            }
            return fixedFigureNumeric
        }
        return nil
    }
}
