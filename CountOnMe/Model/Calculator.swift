//
//  Calculator.swift
//  CountOnMe
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

// deballer optionnel
// integrer X diviser

import Foundation
protocol CalculatorComunication: class {
    func updateResult(calculString: String)
    func displayAlert(message: String)
    func diaplayAlertDivideByZero(message: String)
}

class Calculator {
    
    weak var delegate: CalculatorComunication?
    
    var calculString: String = "1 + 1 = 2" {
        didSet {
            delegate?.updateResult(calculString: calculString)
        }
    }
    
    var elements: [String] {
        //.map return array of the given closure
        return calculString.split(separator: " ").map { "\($0)" }
    }
    
    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "÷"
    }
    
    var expressionHaveResult: Bool {
        return calculString.firstIndex(of: "=") != nil
    }
    
    var divideByZero: Bool {
        return elements.description != "/0"
    }
    
    func addition() {
        if canAddOperator {
            calculString.append(" + ")
        } else {
            delegate?.displayAlert(message: "Un operateur est déja mis !")
            
        }
    }
    
    func substraction() {
        if canAddOperator {
            calculString.append(" - ")
        } else {
            delegate?.displayAlert(message: "Un operateur est déjà mis !")
        }
    }
    
    func division() {
        if canAddOperator {
        calculString.append(" ÷ ")
        } else if divideByZero {
            delegate?.diaplayAlertDivideByZero(message: "Impossible de diviser par zéro !")
       } else {
            delegate?.displayAlert(message: "Un operateur est déjà mis !")
        }
    }
    
    func multiplication() {
        if canAddOperator {
            calculString.append(" x ")
        } else {
            delegate?.displayAlert(message: "Un operateur est déjà mis !")
        }
    }
    
    func equal() {
        guard expressionIsCorrect else {
            delegate?.displayAlert(message: "Entrez une expression correcte !")
            return
        }
        
        guard expressionHaveEnoughElement else {
            delegate?.displayAlert(message: "Demarrez un nouveau calcul !")
            return
        }
        
        // Create local copy of operations
        var operationsToReduce = elements
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Double(operationsToReduce[0])! // !! unwrapped

            
            
        //            if let unwrapped   {
//                left = Int?
//            }
            let operand = operationsToReduce[1]
            let right = Float(operationsToReduce[2])! // !! unwrapped
            
            let result: Float
            switch operand {
            case "+": result = Float(left) + Float(right)
            case "-": result = Float(left) - Float(right)
            case "÷": result = Float(left) / Float(right)
            case "x": result = Float(left) * Float(right)
            default: return
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        calculString.append(" = \(operationsToReduce.first!)") // !! unwrapped
    }
    
    func tapNumberButton(numberText: String) {
        if expressionHaveResult {
            calculString = ""
        }
        calculString.append(numberText)
    }
}
