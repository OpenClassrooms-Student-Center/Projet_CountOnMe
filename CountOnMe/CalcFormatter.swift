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
    
    private var formula = [String]()
    
    //current row used in history
    private var currentRow: Int = 0
    
    private var storedResult: Bool
    
    private var isCreationDecimalValue: Bool
    
    //array of all formula tapped and displayed in rows
    //regional settings applies (comma , thousand separator )
    private var historyOfFormulas = [[String]]()
    
    init() {
        self.storedResult = false
        self.isCreationDecimalValue = false
        resetFormula(defaultValue: "0")
        resetHistory()
    }
    
    var formulaRowQantity: Int {
        return historyOfFormulas.count - 1
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
            } else if isCreationDecimalValue || isInteger(valueTxt: lastElement) {
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
            guard let oldResult = convertToString(figure: figure.result, accuracy: 2)
                else { return }
            resetFormula(defaultValue: oldResult)
        }
        formula.append(operatorChar)
        
        isCreationDecimalValue = false
        
        delegate?.didRefreshScreenResult(screen: historyResultFormatter())
    }
    
    func refreshFormulaHistory() {
        let history = historyResultFormatter()
        delegate?.didRefreshScreenResult(screen: history)
    }
    
    ///manage  formulas per row for history
    ///format each formula by using regional settings
    private func historyResultFormatter() -> String {
        var historyTxt: String = ""
        
        //delete the last row of formula for update
        if currentRow == formulaRowQantity {
            historyOfFormulas.remove(at: currentRow)
        }
        
        //fix formula to be conform to regional settings
        let fixedFormula = fixFormula(formula: formula)
        
        //encode previous formulas lines with linefeeds
        historyOfFormulas.append(fixedFormula)
        if currentRow > 0 {
            for indexRow in 0...currentRow-1 {
                historyTxt += historyOfFormulas[indexRow].joined(separator: " ")
                historyTxt += "\n"
            }
        }
        //encode the current formula
        historyTxt += historyOfFormulas[currentRow].joined(separator: " ")
        return historyTxt
    }
    
    ///fix formula to be conform to regional settings
    func fixFormula(formula: [String]) -> [String] {
        var fixedFormula = [String]()
        
        let decimalSeparator = NumberFormatter().decimalSeparator!
        
        for var value in formula {
            
            if let positionSeparator = value.firstIndex(of: decimalSeparator.last!) {
                value = fixFloatValue(floatTxt: value, decimal: decimalSeparator, indexDecimal: positionSeparator)
            } else {
                value = fixIntegerValue(integerTxt: value, decimal: decimalSeparator)
            }
            
            fixedFormula.append(value)
        }
        return fixedFormula
    }
    
    //format decimal value
    func fixFloatValue(floatTxt: String, decimal: String, indexDecimal: String.Index) -> String {
        var fixedFloatTxt: String
        let distanceFromStart: Int
        let distanceToEnd: Int
        
        distanceFromStart = floatTxt.distance(from: floatTxt.startIndex, to: indexDecimal)
        distanceToEnd = floatTxt.distance(from: indexDecimal, to: floatTxt.endIndex)
        
        let integerPart = String(floatTxt.dropLast(distanceToEnd))
        let decimalPart = floatTxt.dropFirst(distanceFromStart)
        
        fixedFloatTxt = fixIntegerValue(integerTxt: integerPart, decimal: decimal)
        fixedFloatTxt += decimalPart
        
        return fixedFloatTxt
    }
    
    //format integer value to keep thousand separator without comma
    func fixIntegerValue(integerTxt: String, decimal: String) -> String {
        var fixedIntegerTxt = integerTxt
        if var fixedValue = convertToString(figure: integerTxt, thousandSeparator: true),
            !isOperator(fixedValue) {
            if fixedValue.last == decimal.last {
                fixedValue.removeLast()
            }
            fixedIntegerTxt = fixedValue
        }
        return fixedIntegerTxt
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
        
        isCreationDecimalValue = false
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
        guard let lastFigure = formula.last else { return }
        if !canAddOperator(value: lastFigure) { return }
        
        formula.removeLast()
        isCreationDecimalValue = true
        if let float = convertToString(figure: lastFigure, accuracy: 1) {
            formula.append(float)
            delegate?.didRefreshScreenResult(screen: historyResultFormatter())
        }
    }
    
    ///function used when Equal button is tapped
    func addEqual() {
        
        if formula.count >= 3 {
            guard let result = figure.carryOutFormula(formula: formula) else {
                errorNotification()
                return
            }
            
            if let resultTxt = convertToString(figure: result, accuracy: 2) {
                isCreationDecimalValue = false
                formula.append("=")
                formula.append(resultTxt)
                historyOfFormulas[currentRow].append(contentsOf: formula)
                storedResult = true
                
                delegate?.didRefreshScreenResult(screen: historyResultFormatter())
                
                //init settings for a new row in history
                resetFormula(defaultValue: "0")
                currentRow += 1
            }
        }
    }
    
    private func resetFormula(defaultValue: String) {
        formula.removeAll()
        formula.append(defaultValue)
    }
    
    private func resetHistory() {
        historyOfFormulas.removeAll()
        currentRow = 0
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
    
    ///format a numeric figure with an accuracy of x digit after the comma.
    private func convertToString(figure: Double, accuracy: Int ) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = accuracy
        numberFormatter.usesGroupingSeparator = false
        return numberFormatter.string(from: NSNumber(value: figure))
    }
    
    //convert a figure from a string
    private func convertToString(figure: String, accuracy: Int = 0,
                                 thousandSeparator: Bool = false) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.alwaysShowsDecimalSeparator = false
        
        if accuracy != 0 || isCreationDecimalValue || thousandSeparator {
            numberFormatter.alwaysShowsDecimalSeparator = true
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = accuracy
        } else {
            numberFormatter.numberStyle = .none
        }
        numberFormatter.usesGroupingSeparator = thousandSeparator
        if let figureNumeric = numberFormatter.number(from: figure) {
            return numberFormatter.string(from: figureNumeric)
        }
        return nil
    }
}
