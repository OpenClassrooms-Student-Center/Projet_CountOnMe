//
//  ArithmetiqueUnit.swift
//  CountOnMe
//
//  Created by Laurent Debeaujon on 06/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//
import Foundation

class CalcFormatter {
    //delegate used to refresh screen from ViewController
    //or getting  result in CalcFormatterTests
    weak var delegate: CalcFormatterDelegate?
    
    private let figure = Figures()
    
    //current formula storage without regional settings
    private var formula = [String]()
    
    //current row used in screen
    private var currentRow: Int = 0
    
    //old result are available in figure class
    private var storedResult: Bool
    
    //activated when a comma have been tapped
    private var isCreationDecimalValue: Bool
    
    //array of all formula tapped and displayed in rows
    //regional settings applies (comma , thousand separator )
    private var screenResult = [[String]]()
    
    init() {
        self.storedResult = false
        self.isCreationDecimalValue = false
        resetFormula(defaultValue: "0")
        resetScreen()
    }
    
    var screenRowQantity: Int {
        return screenResult.count - 1
    }
    
    ///function used when numeric button is tapped
    func addDigit(digitTxt: String) {
        //old result is lost when a new digit is tapped
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
        refreshScreen()
    }
    
    ///function used when operator button is tapped (+,-,*,/)
    func addOperator(operatorChar: String) {
        if !getFormulaConsistency(value: operatorChar) { return }
        
        //get the old result to use it for the next line
        //if operator is tapped first
        if storedResult && formula.last == "0" {
            guard let oldResult = convertToString(figure: figure.result, accuracy: 2)
                else { return }
            resetFormula(defaultValue: oldResult)
        }
        formula.append(operatorChar)
        
        //end of decimal value design if necessary
        isCreationDecimalValue = false
        
        refreshScreen()
    }
    
    func refreshScreen() {
        let screen = screenResultFormatter()
        delegate?.didRefreshScreenResult(screen: screen)
    }
    
    //refresh the screen and manage formulas per row
    //format each formula by using regional settings
    private func screenResultFormatter() -> String {
        var screenTxt: String = ""
        
        if currentRow == screenRowQantity {
            screenResult.remove(at: currentRow)
        }
        let fixedFormula = fixFormula(formula: formula)
        screenResult.append(fixedFormula)
        if currentRow > 0 {
            for indexRow in 0...currentRow-1 {
                screenTxt += screenResult[indexRow].joined(separator: " ")
                screenTxt += "\n"
            }
        }
        screenTxt += screenResult[currentRow].joined(separator: " ")
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
        
        if floatTxt.last == decimal.last && !isCreationDecimalValue {
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
        
        isCreationDecimalValue = false
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
        isCreationDecimalValue = true
        if let float = convertToString(figure: lastFigure, accuracy: 1) {
            formula.append(float)
            refreshScreen()
        }
    }
    
    ///function used when Equal button is tapped
    func getResult() {
        guard let result = figure.carryOutFormula(formula: formula) else {
            errorNotification()
            return
        }
        
        if let resultTxt = convertToString(figure: result, accuracy: 2) {
            isCreationDecimalValue = false
            formula.append("=")
            formula.append(resultTxt)
            screenResult[currentRow].append(contentsOf: formula)
            storedResult = true
            
            refreshScreen()
            
            //init settings for a new row in screen
            resetFormula(defaultValue: "0")
            currentRow += 1
        }
    }
    
    private func resetFormula(defaultValue: String) {
        formula.removeAll()
        formula.append(defaultValue)
    }
    
    private func resetScreen() {
        screenResult.removeAll()
        currentRow = 0
        screenResult.append(formula)
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
    
    func getDecimalSeparator() -> String {
        let numberFormatter = NumberFormatter()
        return numberFormatter.currencyDecimalSeparator!
    }
    
    func errorNotification() {
           let name = Notification.Name(rawValue: "CarryOutError")
           let notification = Notification(name: name)
           NotificationCenter.default.post(notification)
       }
}
