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
    
    // MARK: Test Model
    func testGivenNumberOne_ThenApplyAdditionSign_ThenGiveResult() {
        calculator.tapNumberButton(numberText: "1")
        
        calculator.addition()
        calculator.tapNumberButton(numberText: "1")
        calculator.equal()
        
        XCTAssertEqual(calculator.calculString, "1 + 1 = 2.0")
    }
    
    func testGivenNumberOne_ThenApplySubstraction_ThenGiveResult() {
        calculator.tapNumberButton(numberText: "1")
        
        calculator.substraction()
        calculator.tapNumberButton(numberText: "1")
        calculator.equal()
        
        XCTAssertEqual(calculator.calculString, "1 - 1 = 0.0")
    }
    
    // MARK: Alert
    func testGivenNumberOne_ThenApplyAdditionTwoTimes_ThenGiveResultAlert() {
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
    
    func testGivenNumberOne_WhenApplyTimesTen_ThenResultCorect() {
        calculator.tapNumberButton(numberText: "1")
        
        calculator.multiplication()
        calculator.tapNumberButton(numberText: "10")
        calculator.equal()
        
        XCTAssertEqual(calculator.calculString, "1 x 10 = 10.0")
    }
    
    func testGivenNumberOne_WhenDivideByTwo_ThenResultIsCorrect() {
        calculator.tapNumberButton(numberText: "1")
        
        calculator.division()
        calculator.tapNumberButton(numberText: "2")
        calculator.equal()
        
        XCTAssertEqual(calculator.calculString, "1 ÷ 2 = 0.5")
    }
    
    func testGivenNumberOne_WhenCanAddOperatorIsRepeat_ThenPrintAlertAndReset() {
        calculator.tapNumberButton(numberText: "1")
        
        calculator.division()
        calculator.division()
        
        XCTAssertEqual(calculator.calculString, "1 ÷ ")
    
        calculator.tapNumberButton(numberText: "1")
        
        calculator.multiplication()
        calculator.multiplication()
        
        XCTAssertEqual(calculator.calculString, "1 ÷ 1 x ")
        
        calculator.reset()
        
        XCTAssertEqual(calculator.calculString, "")
   
    }
    
    func testGivenNumberOne_WhenTryDivideByZero_ThenInitialiseNil() {
        calculator.tapNumberButton(numberText: "1")
        
        calculator.division()
        calculator.tapNumberButton(numberText: "0")
        calculator.equal()
        
        XCTAssertEqual(calculator.calculString, "")
    }

}
