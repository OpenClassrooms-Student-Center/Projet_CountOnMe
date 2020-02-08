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

class Calculator {
    
    weak var delegate: CalculatorComunication?
    
    var calculString = "1 + 1 = 2" {
        didSet {
            delegate?.updateResult(calculString: calculString)
        }
    }
    
    var elements: [String] {
        //Separate calcul by "" and loop inside
        return calculString.split(separator: " ").map { "\($0)" }
    }
    
    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" || elements.last != "-" || elements.last != "÷" || elements.last != "x"
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
            
            guard var left = Float(operationsToReduce[0]) else { return }
            var operand = operationsToReduce[1]
            guard var right = Float(operationsToReduce[2]) else { return }
            
            let result: Float
            
            var operandIndex = 1 // Start at one for we can remove extra calcul for priorities
            
            // Search if there is multiply of divide take
            if let index = operationsToReduce.firstIndex(where: {["x","÷"].contains($0)}) {
                
                operandIndex = index
                left = Float(operationsToReduce[index - 1])!
                operand = operationsToReduce[index]
                right = Float(operationsToReduce[index + 1])!
                
            }
            
            result = calculate(left: left, right: right, operand: operand)
            
            for _ in 1...3 {
                
                operationsToReduce.remove(at: operandIndex - 1)
                print(operationsToReduce)
                print(result)
            }
            operationsToReduce.insert("\(result)", at: operandIndex - 1 )
            print(operationsToReduce)
        }
        guard let finalResult = operationsToReduce.first else { return }
        calculString.append(" = \(finalResult)")
    }
    
    func calculate(left: Float, right: Float, operand: String) -> Float {
        
        let result: Float
        switch operand {
        case "+": result = left + right
        case "-": result = left - right
        case "÷": result = left / right
        case "x": result = left * right
        default: fatalError()
        }
        return result
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
