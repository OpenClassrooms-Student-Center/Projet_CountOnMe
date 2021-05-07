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
        

    
    mutating func continueCalcul(){
        //we check if we have an value in element.last
        guard let first = elements.last else {
            return
        }
        //if yes, we check if the calcul have a result
        if expressionHaveResult{
            //if yes, we reset the calcul and we give first at updateInfo
            resetInfo()
            updateInfo(first)
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
    
    //we check if we already have an operator
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
    }
    
    //we check if we have a value 
    var alreadyANumber : Bool{
       return currentValue != ""
    }

    //we check if we have an equal
    var expressionHaveResult: Bool {
        return text.firstIndex(of: "=") != nil
    }
    

    //we check if we have a point
    func haveAPoint() -> Bool {
        //return true if we already have a point else return false
        return elements.last?.contains(where: {$0 == "."}) ?? false
    }
    
    
    //we check if we have a divison
    private var haveADivision = false
    
    // we check if we have an division by zero
    mutating func divideByZero () -> Bool{
        if haveADivision == true && text.last == "0"{
            //if yes, we remove the 0 and we return true
            text.removeLast()
            return haveADivision
        }
        //else we pass the value of haveAdivision to false and we return false
        haveADivision = false
        return haveADivision
    }
    //we change the value of haveADivison to true
    mutating func updateHaveADivision(){
        haveADivision = true
    }
    
    //this function return a float number after an addition or a substraction
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
    
    //this function return a float number after a multiplication or a division
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
        //we check all array boxes for check if it's a multiplication or a divison before doing additions and substractions
        while i < operationsToReduce.count {
            if operationsToReduce[i] == "x" || operationsToReduce[i] == "/"{
                let result : Float
                result = multiplicationAndDivision(operationsToReduce, i)
                //when the multiplication or the divison is done, we remove the boxe after and before the operator and the result takes the boxe of the operator
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
        
        //we check if the float ends with ".0" if yes, we remove this 
        if operationsToReduce[0].last == "0"{
            operationsToReduce[0].removeLast()
            if operationsToReduce[0].last == "."{
                operationsToReduce[0].removeLast()
            }
        }
        return operationsToReduce
    }
}


