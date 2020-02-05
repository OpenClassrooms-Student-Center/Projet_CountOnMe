//
//  Calculator.swift
//  CountOnMe
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//


import Foundation
protocol CalculatorComunication: class {
    func updateResult(calculString: String)
    func displayAlert(message: String)
}

class Calculator: NSObject {
    
    weak var delegate: CalculatorComunication?
    
    var calculString: String = "1 + 1 = 2" {
        didSet {
            delegate?.updateResult(calculString: calculString)
        }
    }
    
    var elements: [String] {
        //Separate calcul by "" and do loop
        return calculString.split(separator: " ").map { "\($0)" }
    }
    
    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" || elements.last != "-"
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "÷" && elements.last != "x"
    }
    
    var expressionHaveResult: Bool {
        return calculString.firstIndex(of: "=") != nil
    }
    
    var divideByZero: Bool {
        return calculString.contains("÷ 0")
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
        
        guard divideByZero == false  else {
            calculString = ""
            return
        }
        
        // Create local copy of operations
        var operationsToReduce = elements
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            
            guard let left = Float(operationsToReduce[0]) else { return } 
            
            let operand = operationsToReduce[1]
            guard let right = Float(operationsToReduce[2]) else { return }
 
            var result: Float
            
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "÷": result = left / right
            case "x": result = left * right
            default: return
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        guard let result = operationsToReduce.first else { return }
        calculString.append(" = \(result)")
    }
    
    func tapNumberButton(numberText: String) {
        if expressionHaveResult {
            calculString = ""
        }
        calculString.append(numberText)
    }
    
    func reset() {
        calculString = ""
    }
}
