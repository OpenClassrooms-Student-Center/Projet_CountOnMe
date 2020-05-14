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
    var elements: [String] = []
    var result: Double = 0.0

    var getCurrentSeparator: String {
        let numberFormatter = NumberFormatter()
        return numberFormatter.decimalSeparator
    }
    
    var screenResult: String {
        return elements.joined(separator: " ")
    }
    
    func addOperator(operatorChar: String) {
        elements.append(operatorChar)
        delegate?.didRefreshScreenResult()
    }
    
    func addDigit(digitTxt: String) {
        if let figure = elements.last,
            Double(figure) != nil {
            elements.removeLast()
            elements.append(figure+digitTxt)
        } else {
            elements.append(digitTxt)
        }
        
        delegate?.didRefreshScreenResult()
    }
    
    func deleteElement(all: Bool) {
        if all == true {
            elements.removeAll()
        } else {
            elements.removeLast()
        }
        delegate?.didRefreshScreenResult()
    }
    
    func reverseFigure() {
        guard var figure = elements.last else { return }
        elements.removeLast()
        
        if figure.first == "-" {
            figure.removeFirst()
        } else {
            figure.insert("-", at: figure.startIndex)
        }
        
        elements.append(figure)
        
        delegate?.didRefreshScreenResult()
    }
    
    func addComma() {
        guard let figure = elements.last else { return }
        elements.removeLast()
        elements.append(figure + getCurrentSeparator)
        delegate?.didRefreshScreenResult()
    }
        
    func getResult() {
        
        var operationsToReduce = elements
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Double(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Double(operationsToReduce[2])!
        
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "*": result = left * right
            case "/": result = left / right
            case "%": result = left / 100 * right
            default: fatalError("Unknown operator !")
            }
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        if result.truncatingRemainder(dividingBy: 1) != 0 {
            elements.append(" = " + String(format: "%.2f", result))
        } else {
            elements.append(" = \(Int(result))")
        }
    
        delegate?.didRefreshScreenResult()
    }
   
}

extension Double {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}
