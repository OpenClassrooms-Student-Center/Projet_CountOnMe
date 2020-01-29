//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe


class SimpleCalcTests: XCTestCase {
    
    var calculator: Calculator!
    
    
    override func setUp() {
        super.setUp()
        calculator = Calculator()
    }
    
    override func tearDown() {
        super.tearDown()
        calculator = nil
    }
    
    func testGivenNumberOne_ThenApplyAdditionSign_ThenGiveResult() {
        calculator.tapNumberButton(numberText: "1")
        
        calculator.addition()
        calculator.tapNumberButton(numberText: "1")
        calculator.equal()
        
        XCTAssertEqual(calculator.calculString, "1 + 1 = 2")
    }
    
    
    func testGivenNumberOne_ThenApplySubstraction_ThenGiveResult() {
        calculator.tapNumberButton(numberText: "1")
        
        calculator.substraction()
        calculator.tapNumberButton(numberText: "1")
        calculator.equal()
        
        XCTAssertEqual(calculator.calculString, "1 - 1 = 0")
    }
    
    func testGivenNumberOne_ThenApplyAdditionTwoTimes_ThenGiveResultError() {
        calculator.tapNumberButton(numberText: "1")
       
        calculator.addition()
        calculator.addition()
        
        XCTAssertEqual(calculator.calculString, "1 + ")
    }
    
    
    func testGivenNumberOne_ThenApplySubstractionTwoTimes_ThenGiveAlert() {
        calculator.tapNumberButton(numberText: "1")
        
        calculator.substraction()
        calculator.substraction()
        
        XCTAssertEqual(calculator.calculString, "1 - ")
    }
    
    func testGivenNumberOne_WhenExpressionIsNotCorrect_ThenAlertMessage() {
        calculator.tapNumberButton(numberText: "1")
        
        calculator.substraction()
        calculator.equal()
        
        XCTAssertEqual(calculator.calculString, "1 - ")
    }
    
    func testGivenNumberOne_WhenExpressionDontHaveEnoughElement_ThenAlertMessage() {
        calculator.tapNumberButton(numberText: "1")

        calculator.equal()

        XCTAssertEqual(calculator.calculString, "1")
    }
    
    func testGivennumberOne_WhenDoReset_ThenResetScreen_Withzero() {
        calculator.tapNumberButton(numberText: "1")
        
        calculator.resetCalculator()
        
        XCTAssertEqual(calculator.calculString, "0")
        
    }
    
}
