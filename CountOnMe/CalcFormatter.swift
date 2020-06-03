//
//  ArithmetiqueUnit.swift
//  CountOnMe
//
//  Created by Laurent Debeaujon on 06/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//
import Foundation

class CalcFormatter {
    ///delegate used to
    weak var delegate: CalcFormatterDelegate?
    
    private let figure = Figures()
    private var formula = [String]()
    private var lastRow: Int = 0
    private var storedResult: Bool
    private var isFloatValue: Bool
    private var screenResult = [[String]]()
    
    init() {
        self.storedResult = false
        self.isFloatValue = false
        resetFormula(defaultValue: "0")
        resetScreen()
        
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
            } else if isFloatValue || (Int(lastElement) != nil) {
                figure = lastElement + figure
            }
        }
        formula.append(figure)
        refreshScreen()
    }
    
    ///function used when operator button is tapped (+,-,*,/)
    func addOperator(operatorChar: String) {
        if !getFormulaConsistency(value: operatorChar) {
            return
        }
        //get back the old Result to use it for the next row
        if storedResult && formula.last == "0" {
            guard let oldResult = convertToString(figure: figure.result, accuracy: 2) else { return }
            resetFormula(defaultValue: oldResult)
        }
        formula.append(operatorChar)
        isFloatValue = false
        refreshScreen()
    }
    
    func refreshScreen() {
        let screen = screenResultFormatter()
        delegate?.didRefreshScreenResult(screen: screen)
    }
    
    private func screenResultFormatter() -> String {
        var screenTxt: String = ""
        
        if lastRow == (screenResult.count - 1) {
            screenResult.remove(at: lastRow)
        }
        let fixedFormula = fixFormula(formula: formula)
        screenResult.append(fixedFormula)
        if lastRow > 0 {
            for indexRow in 0...lastRow-1 {
                screenTxt += screenResult[indexRow].joined(separator: " ")
                screenTxt += "\n"
            }
        }
        screenTxt += screenResult[lastRow].joined(separator: " ")
        return screenTxt
    }
    
    func fixFormula(formula: [String]) -> [String] {
        var fixedFormula = [String]()
        let decimalSeparator = getDecimalSeparator()
        for var value in formula {
            if let positionSeparator = value.firstIndex(of: decimalSeparator.last!) {
                value = fixFloatValue(floatTxt: value, decimal: decimalSeparator, indexDecimal: positionSeparator)
            } else {
              if let fixedValue = convertToString(figure: value, thousandSeparator: true),
                !isOperator(value) {
                value = fixIntegerValue(integerTxt: fixedValue, decimal: decimalSeparator)
                }
            }
           
            fixedFormula.append(value)
        }
        return fixedFormula
    }
    
    func fixFloatValue(floatTxt: String, decimal: String, indexDecimal: String.Index) -> String {
        var fixedFloatTxt: String
        let distanceFrom: Int
        let distanceTo: Int
        distanceFrom = floatTxt.distance(from: floatTxt.startIndex, to: indexDecimal)
        distanceTo = floatTxt.distance(from: indexDecimal, to: floatTxt.endIndex)
        let integerPart = floatTxt.dropLast(distanceTo)
        let decimalPart = floatTxt.dropFirst(distanceFrom)
        
        if let fixedIntegerPart = convertToString(figure: String(integerPart), thousandSeparator: true) {
            fixedFloatTxt = fixedIntegerPart
            fixedFloatTxt = fixIntegerValue(integerTxt: fixedFloatTxt, decimal: decimal)
            fixedFloatTxt += decimalPart
        } else {
            return ""
        }
        
        if floatTxt.last == decimal.last && !isFloatValue {
           fixedFloatTxt.removeLast()
        }
        return fixedFloatTxt
    }
    func fixIntegerValue(integerTxt: String, decimal: String) -> String {
        var fixedIntegerTxt = integerTxt
        if integerTxt.last == decimal.last {
           fixedIntegerTxt.removeLast()
        }
        return fixedIntegerTxt
    }
    
    ///used when CE or C button are tapped
    func deleteElement(all: Bool) {
        if all == true {
            resetFormula(defaultValue: "0")
            resetScreen()
        } else {
            formula.removeLast()
            if formula.count == 0 {
                formula.append("0")
            }
        }
        refreshScreen()
    }
    
    ///function used when +/- button is tapped
    func reverseFigure() {
        guard var figure = formula.last else { return }
        if !getFormulaConsistency(value: figure) { return  }
        
        isFloatValue = false
        formula.removeLast()
        
        if figure.first == "-" {
            figure.removeFirst()
        } else {
            figure.insert("-", at: figure.startIndex)
        }
        formula.append(figure)
        
        refreshScreen()
    }
    
    ///function used when comma button is tapped

    func addComma() {
        guard let lastFigure = formula.last else { return }
        if !getFormulaConsistency(value: lastFigure) { return }
        
        formula.removeLast()
        isFloatValue = true
        if let float = convertToString(figure: lastFigure, accuracy: 1) {
            formula.append(float)
            refreshScreen()
        }
    }
    
    ///function used when Equal button is tapped
    func getResult() {
        guard let result = figure.carryOutFormula(formula: formula) else { return }
        
        if let resultTxt = convertToString(figure: result, accuracy: 2) {
            isFloatValue = false
            formula.append("=")
            formula.append(resultTxt)
            screenResult[lastRow].append(contentsOf: formula)
            storedResult = true
            
            refreshScreen()
            
            //init settings for a new row in screen
            resetFormula(defaultValue: "0")
            lastRow += 1
        }
    }
    
    private func resetFormula(defaultValue: String) {
        isFloatValue = false
        formula.removeAll()
        formula.append(defaultValue)
    }
    
    private func resetScreen() {
        screenResult.removeAll()
        lastRow = 0
        screenResult.append(formula)
    }
    
    private func isOperator(_ value: String) -> Bool {
        if value == "+" || value == "-" || value == "/" || value == "x" || value == "=" {
            return true
        }
        return false
    }
    
    ///check the consistency of the current formula
    private func getFormulaConsistency(value: String) -> Bool {
        if let lastValue = formula.last {
            // check if 2 consecutive character have been tapped
            if isOperator(value) && isOperator(lastValue) {
                return false
            }
        }
        return true
    }
    
    ///format a numeric figure with an accuracy of x digit after the comma.
    ///and return a String
    private func convertToString(figure: Double, accuracy: Int ) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = accuracy
        numberFormatter.usesGroupingSeparator = false
        return numberFormatter.string(from: NSNumber(value: figure))
    }
    
    //convert a figure from a string
    private func convertToString(figure: String, accuracy: Int = 0, thousandSeparator: Bool = false) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.alwaysShowsDecimalSeparator = false
        if accuracy != 0 || isFloatValue || thousandSeparator {
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
    
    func getDecimalSeparator() -> String {
        let numberFormatter = NumberFormatter()
        return numberFormatter.currencyDecimalSeparator!
    }
}
