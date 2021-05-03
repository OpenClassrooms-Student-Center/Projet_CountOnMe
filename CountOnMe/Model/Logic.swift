//
//  Logic.swift
//  CountOnMe
//
//  Created by Brian Friess on 20/04/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

struct Logic{
    
    private var text = ""
        
    
    
    
    
    mutating func takeTheRest(_ rest : String){
        if expressionHaveResult{
            resetInfo()
            updateInfo(rest)
        }
    }
    
    var currentValue : String{
        return text
    }

    //the function, add a caracter at textAppend
    mutating func updateInfo(_ value : String){
        self.text.append(value)
    }
    
    //we reset the value of textAppend
    mutating func resetInfo(){
        self.text = ""
    }
    

    var elements: [String] {
        return text.split(separator: " ").map { "\($0)" }
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
    }
    
    //we check if we have a value 
    var alreadyANumber : Bool{
       return currentValue != ""
    }

    
    var expressionHaveResult: Bool {
        return text.firstIndex(of: "=") != nil
    }
    
    //if we add a point, haveAPoint = true
    private var haveAPoint = false
    
    //we return the value of haveAPoint
    var currentStatePoint : Bool{
        return haveAPoint
    }
    
    //this function is used to change the state of haveAPoint
    mutating func updateHaveAPoint() {
        //if we have a point, we pass haveAPoint to true
        if text.last == "."{
            self.haveAPoint = true
        }
        //if we have " " it's because we have an operator, so we can pass haveAPoint to true
        if text.last == " "{
            self.haveAPoint = false
        }
    }
    
    
    //we check if we have a divison
    private var haveADivision = false
    
    // we check if we have an division by zero
    mutating func divideByZero () -> Bool{
        if haveADivision == true && text.last == "0"{
            //if yes, we remove the 0 and we return true
            text.removeLast()
            return true
        }
        //else we pass the value of haveAdivision to false and we return false
        haveADivision = false
        return false
    }
    
    
    //we change the value of haveADivison to true
    mutating func updateHaveADivision(){
        haveADivision = true
    }
    
    
    
    
    private func additionAndSubstraction(_ calcul : [String]) -> Float{
        let result: Float
        let left = Float(calcul[0])!
        let operand = calcul[1]
        let right = Float(calcul[2])!

        switch operand {
        case "+": result = left + right
        case "-": result = left - right
        default: fatalError()
        }
        return result
    }
    
    
    private func multiplicationAndDivision(_ calcul : [String], _ range : Int) -> Float{
        let result : Float
        switch calcul[range]{
            case "x" : result = Float(calcul[range-1])! * Float(calcul[range+1])!
            case "/" :result = Float(calcul[range-1])! / Float(calcul[range+1])!
            default : fatalError()
        }
        return result
    }
    
    
    var operationsToReduce : [String]{
        // Create local copy of operations
        var operationsToReduce = elements
        var i = 0
        while i < operationsToReduce.count {
            if operationsToReduce[i] == "x" || operationsToReduce[i] == "/"{
                let result : Float
                result = multiplicationAndDivision(operationsToReduce, i)
                operationsToReduce[i] = String(result)
                operationsToReduce.remove(at: i+1)
                operationsToReduce.remove(at: i-1)
                i = 0
            }
            i += 1
        }
        //we do addition and soustraction thanks to the function additionAndSubstraction
        while operationsToReduce.count > 1 {
             let result: Float
             result = additionAndSubstraction(operationsToReduce)
             operationsToReduce = Array(operationsToReduce.dropFirst(3))
             operationsToReduce.insert("\(result)", at: 0)
            }
        
        if operationsToReduce[0].last == "0"{
            operationsToReduce[0].removeLast()
            if operationsToReduce[0].last == "."{
                operationsToReduce[0].removeLast()
            }
        }
        return operationsToReduce
    }
}

//enlever les fatal error
//class custom pour arrondir les boutons
