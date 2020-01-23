//
//  Calculator.swift
//  CountOnMe
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//
//1 + 1 ==
// -1
import Foundation
protocol CalculatorComunication: class {
    func updateResult(calculString: String)
    func displayAlert(message: String)
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
        return elements.last != "+" && elements.last != "-"
    }
    
    var expressionHaveResult: Bool {
        return calculString.firstIndex(of: "=") != nil
        
    }
    
    func addition() {
        if canAddOperator {
            calculString.append(" + ")
        } else { delegate?.displayAlert(message: "Un operateur est déja mis !") }
    }
    
    func equal() {
        
        guard expressionIsCorrect else {
            
            //            let alertVC = UIAlertController(title: "Zéro!", message: "Entrez une expression correcte !", preferredStyle: .alert)
            //            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            //            return self.present(alertVC, animated: true, completion: nil)
            return
        }
        
        guard expressionHaveEnoughElement else {
            //            let alertVC = UIAlertController(title: "Zéro!", message: "Démarrez un nouveau calcul !", preferredStyle: .alert)
            //            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            //            return self.present(alertVC, animated: true, completion: nil)
            return
        }
        
        // Create local copy of operations
        var operationsToReduce = elements
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            
            let result: Int
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            default: fatalError("Unknown operator !")
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        calculString.append(" = \(operationsToReduce.first!)")
    }
    
    func substraction() {
        if canAddOperator {
            calculString.append(" - ")
        } else {
            //            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            //            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            //            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func tapNumberButton(numberText: String) {
        if expressionHaveResult {
            calculString = ""
        }
        calculString.append(numberText)
    }
}
