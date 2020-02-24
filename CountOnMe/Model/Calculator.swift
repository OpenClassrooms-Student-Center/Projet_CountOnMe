//
//  Calculator.swift
//  CountOnMe
//
//  Created by mac on 2020/1/13.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//


import Foundation
//MARK: Protocol
/// Contract to update and alert when alert its needed
protocol CalculatorComunication: class {
    func updateResult(calculString: String)
    func displayAlert(message: String)
}

final class Calculator {
    
    weak var delegate: CalculatorComunication?
    
    var calculString = "1 + 1 = 2" {
        didSet {
            delegate?.updateResult(calculString: calculString)
        }
    }
    
    private var elements: [String] {
        //Separate calcul by "" and loop inside
        return calculString.split(separator: " ").map { "\($0)" }
    }
    
    /// Error check computed variables
    private var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "÷" && elements.last != "x"
    }
    
    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    private var canStartByOperator: Bool {
        if calculString >= "0" && calculString <= "9" {
            return elements.count >= 1
        } else {
            delegate?.displayAlert(message: "S'il vous plait ne commencer pas par un operateur !")
        }
        return false
    }
    
    private var expressionHaveResult: Bool {
        return calculString.firstIndex(of: "=") != nil
    }
    
    private var divideByZero: Bool {
        return calculString.contains("÷ 0")
    }
    
    //MARK: Operator
    func addition() {
        if canStartByOperator && expressionIsCorrect {
                calculString.append(" + ")
            } else { delegate?.displayAlert(message: "Un operateur est déja mis !") }
        }
    
    
    func substraction() {
        if canStartByOperator && expressionIsCorrect {
                calculString.append(" - ")
            } else { delegate?.displayAlert(message: "Un operateur est déjà mis !") }
        
    }
    
    func division() {
        if canStartByOperator && expressionIsCorrect {
                calculString.append(" ÷ ")
            } else { delegate?.displayAlert(message: "Un operateur est déjà mis !") }
        }
    
    
    func multiplication() {
        if canStartByOperator && expressionIsCorrect {
                calculString.append(" x ")
            } else { delegate?.displayAlert(message: "Un operateur est déjà mis !") }
        
    }
    
    func equal() {
        // Check properties
        guard expressionIsCorrect else {
            delegate?.displayAlert(message: "Entrez une expression correcte !")
            return
        }
        
        guard expressionHaveEnoughElement else {
            delegate?.displayAlert(message: "Demarrez un nouveau calcul !")
            return
        }
        
        guard !divideByZero else {
            delegate?.displayAlert(message: "Il est impossible de diviser par zéro !")
            calculString = ""
            return
        }
        
        // Create local copy of operations
        var operationsToReduce = elements
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            
            guard var left = Double(operationsToReduce[0]) else { return }
            var operand = operationsToReduce[1]
            guard var right = Double(operationsToReduce[2]) else { return }
            
            let result: Double
            
            var operandIndex = 1 // Start at one or we can't assign index to (index - 1)
            
            // Search if there is multiply of divide sign then assign index
            if let index = operationsToReduce.firstIndex(where: { $0 == "x" || $0 == "÷" }) {
                
                operandIndex = index
                if let leftunwrapp = Double(operationsToReduce[index - 1]) { left = leftunwrapp }
                operand = operationsToReduce[index]
                if let rightUnwrapp = Double(operationsToReduce[index + 1]) { right = rightUnwrapp }
            }
            
            result = calculate(left: Double(left), right: Double(right), operand: operand)
            
            
            for _ in 1...3 { // Loop inside index to remove extra operator
                
                operationsToReduce.remove(at: operandIndex - 1)
                print("Nous avons supprimé :\(operationsToReduce)")
            }
            operationsToReduce.insert(formatResult(result: Double(result)), at: operandIndex - 1 )
            print("Votre resultat :\(result)")
            print("Le resultat formater :\(operationsToReduce)")
            
        }
        guard let finalResult = operationsToReduce.first else { return }
        calculString.append(" = \(finalResult)")
    }
    
    // MARK: Calcul
    /// calculate to update result
    private func calculate(left: Double, right: Double, operand: String) -> Double {
        
        let result: Double
        switch operand {
        case "+": result = left + right
        case "-": result = left - right
        case "÷": result = left / right
        case "x": result = left * right
        default: return 0.0
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
    
    private func formatResult(result: Double) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 3
        
        guard let resultFormated = formatter.string(from: NSNumber(value: result)) else { return String() }
        
        guard resultFormated.count <= 10 else {
            return String(result)
        }
        return resultFormated
    }
}
