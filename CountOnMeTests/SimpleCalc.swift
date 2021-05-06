//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

final class SimpleCalcTests: XCTestCase {
    
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
        calculator.multiplication()
        calculator.tapNumberButton(numberText: "1")
        calculator.division()
        calculator.tapNumberButton(numberText: "1")
        calculator.substraction()
        calculator.tapNumberButton(numberText: "1")
        
        calculator.equal()
        
        XCTAssertEqual(calculator.calculString, "1 + 1 x 1 ÷ 1 - 1 = 1")
    }
    
    // MARK: Test Alert
    
    // ExpressionIsCorrect
    // Cannot finish by operator
    func testGivenNumberOne_WhenExpressionIsNotCorrect_ThenAlertMessage() {
        calculator.tapNumberButton(numberText: "1")
        
        calculator.substraction()
        calculator.equal()
        
        calculator.tapNumberButton(numberText: "1")
        calculator.multiplication()
        
        XCTAssertEqual(calculator.calculString, "1 - 1 x ")
    }
    
    // ExpressionHaveEnoughElements
    func testGivenNumberOne_WhenExpressionDontHaveEnoughElement_ThenAlertMessage() {
        calculator.tapNumberButton(numberText: "1")
        
        calculator.equal()
        
        XCTAssertEqual(calculator.calculString, "1")
    }
    
    // Start By operator
    func testGivenPresentationCalcul_WhenTryMultiplicationOrAddition_ThenShowAlert() {
        calculator.reset()
        
        calculator.multiplication()
        calculator.addition()
        
        XCTAssertEqual(calculator.calculString, "")
    }
    
    //MARK: TDD
    // Division by zero
    func testGivenNumberOne_WhenTryDivideByZero_ThenInitialiseNil() {
        calculator.tapNumberButton(numberText: "1")
        
        calculator.division()
        calculator.tapNumberButton(numberText: "0")
        calculator.equal()
        
        XCTAssertEqual(calculator.calculString, "")
    }
    
    // Format Result
    func testGivenNumberOne_WhenDoFormat_ThenGiveResult() {
        calculator.tapNumberButton(numberText: "10")
        
        calculator.division()
        calculator.tapNumberButton(numberText: "3")
        calculator.equal()
        
        XCTAssertEqual(calculator.calculString, "10 ÷ 3 = 3.333")
    }
    
    // Big number
    func testGivenNumberOne_WhenApplyTenZero_ThenResultCorect() {
        calculator.tapNumberButton(numberText: "10000000000")
        
        calculator.multiplication()
        calculator.tapNumberButton(numberText: "10000000000")
        calculator.equal()
        
        XCTAssertEqual(calculator.calculString, "10000000000 x 10000000000 = 1e+20")
    }
}
