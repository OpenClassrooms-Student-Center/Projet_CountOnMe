//
//  CountOnMeTestCase.swift
//  CountOnMeTests
//
//  Created by Brian Friess on 23/04/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CountOnMeTestCase: XCTestCase {

    var logic: Logic!

    override func setUp() {
        super.setUp()
        logic = Logic()
    }
    
    private func addNumbersFive(){
        logic.updateInfo("5")
    }
    
    enum Operator : String{
        case plus
        case less
        case multiplication
        case division
    }
    
    private func addOperator(_ styleOperator : Operator){
        switch styleOperator{
        case .plus:
            logic.updateInfo(" + ")
        case .less:
            logic.updateInfo(" - ")
        case .division:
            logic.updateInfo(" / ")
        case .multiplication:
            logic.updateInfo(" x ")
        }
    }
    

    func testAdditionIsComplete_PushEqualButton_HaveAResult(){
        
        addNumbersFive()
        addOperator(.plus)
        addNumbersFive()
        
        XCTAssert(logic.expressionHaveEnoughElement)
        XCTAssert(logic.elements == ["5","+","5"])
        XCTAssert(logic.operationsToReduce == ["10"])
    }
    
    func testlessIsComplete_PushEqualButton_HaveAResult(){
        
        addNumbersFive()
        addOperator(.less)
        addNumbersFive()
        
        XCTAssert(logic.expressionHaveEnoughElement)
        XCTAssert(logic.elements == ["5","-","5"])
        XCTAssert(logic.operationsToReduce == ["0"])
    }
    
    func testTheCalculationHaveAnOperator_AddPlus_cantAddANewOperator(){
    
        addNumbersFive()
        addOperator(.plus)
        
        addOperator(.plus)
        
        XCTAssertFalse(logic.canAddOperator)
    }
    
    func testTheCalculationHaveAnOperator_AddLess_cantAddANewOperator(){
    
        addNumbersFive()
        addOperator(.plus)
        
        addOperator(.less)
        
        XCTAssertFalse(logic.canAddOperator)
    }
    
    func testTheCalculationHaveAnOperator_AddMultiplication_cantAddANewOperator(){
    
        addNumbersFive()
        addOperator(.plus)
        
        addOperator(.multiplication)
        
        XCTAssertFalse(logic.canAddOperator)
    }
    
    func testTheCalculationHaveAnOperator_AddDivision_cantAddANewOperator(){
        addNumbersFive()
        addOperator(.plus)
        
        addOperator(.division)
        
        XCTAssertFalse(logic.canAddOperator)
    }
    
    
    func testHaveFinishedACalculation_StartANewCalculation_CalculationReset(){
        addNumbersFive()
        addOperator(.plus)
        addNumbersFive()
        logic.updateInfo(" = ")
        XCTAssert(logic.expressionHaveResult)
        
        
        logic.resetInfo()
        addNumbersFive()
        
        XCTAssert(logic.elements == ["5"])
    }
    
    func testMultiplacationIsComplete_PushEqualButton_HaveAResult(){
        addNumbersFive()
        addOperator(.multiplication)
        addNumbersFive()
        
        XCTAssert(logic.expressionHaveEnoughElement)
        
        XCTAssert(logic.elements == ["5","x","5"])
        XCTAssert(logic.operationsToReduce == ["25"])
    }
    
    func testDivisionComplete_PushEqualButton_HaveAResult(){
        addNumbersFive()
        addOperator(.division)
        logic.updateHaveADivision()
        addNumbersFive()
        
        XCTAssertFalse(logic.divideByZero())
        XCTAssert(logic.expressionHaveEnoughElement)
        
        XCTAssert(logic.elements == ["5","/","5"])
        XCTAssert(logic.operationsToReduce == ["1"])
    }
    
    func testCalculateComplete_PushEqualButton_CheckPriorities(){
        addNumbersFive()
        addOperator(.plus)
        addNumbersFive()
        addOperator(.multiplication)
        addNumbersFive()
        
        XCTAssert(logic.expressionHaveEnoughElement)
        
        XCTAssert(logic.elements == ["5","+","5","x","5"])
        XCTAssert(logic.operationsToReduce == ["30"])
    }
    
    
    func testCalculteWithPointAndPriorites_PushEqualButton_HaveAFloatResult(){
        addNumbersFive()
        logic.updateInfo(".")
        addNumbersFive()
        addOperator(.plus)
        addNumbersFive()
        addOperator(.multiplication)
        addNumbersFive()
        logic.updateInfo(".")
        addNumbersFive()

        
        XCTAssert(logic.expressionHaveEnoughElement)
        XCTAssert(logic.elements == ["5.5","+","5","x","5.5"])
        XCTAssert(logic.operationsToReduce == ["33"])
    }
    
    func testStartANewCalcul_addAnOperatorBeforeANumber_HaveAnError(){
        XCTAssertFalse(logic.alreadyANumber)
    }
    
    func testStartANewDivision_DivideByZero_removeZero(){
        addNumbersFive()
        addOperator(.division)
        logic.updateHaveADivision()
        logic.updateInfo("0")
        
        XCTAssert(logic.elements == ["5","/","0"])
        XCTAssert(logic.divideByZero())
        
        XCTAssert(logic.elements ==  ["5","/"])
    }
    
    func testStarteNewCalcul_AddAPoint_CantAddAnotherPointBeforeAnOperator(){
        addNumbersFive()
        XCTAssertFalse(logic.haveAPoint())
        
        
        logic.updateInfo(".")
        addNumbersFive()
        XCTAssert(logic.haveAPoint())
        
        addOperator(.division)
        XCTAssertFalse(logic.haveAPoint())
    }
    
    func testCalculHaveAResult_AddAnOperatorAndNumber_HaveAResult(){
        
        logic.continueCalcul()
        addNumbersFive()
        addOperator(.plus)
        addNumbersFive()
        logic.updateInfo(" = \(logic.operationsToReduce.first!)")
        XCTAssert(logic.elements == ["5","+","5","=","10"])
        
        
        logic.continueCalcul()
        addOperator(.multiplication)
        
        addNumbersFive()
        XCTAssert(logic.elements == ["10","x","5"])
    }
    
    
}
