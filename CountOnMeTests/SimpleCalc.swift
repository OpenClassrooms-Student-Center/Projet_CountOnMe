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
        
        XCTAssertEqual(calculator.calculString, "1 + 1 x 1 ÷ 1 - 1 = 1.0")
    }
    
    //
    func testGivenNumberOne_WhenApplyTenZero_ThenResultCorect() {
         calculator.tapNumberButton(numberText: "10000000000")

         calculator.multiplication()
         calculator.tapNumberButton(numberText: "10000000000")
         calculator.equal()

         XCTAssertEqual(calculator.calculString, "10000000000 x 10000000000 = 1e+20")
     }
    
    // MARK: Test Alert
    
    // ExpressionIsCorrect
       func testGivenNumberOne_WhenExpressionIsNotCorrect_ThenAlertMessage() {
           calculator.tapNumberButton(numberText: "1")
           
           calculator.substraction()
           calculator.equal()
           
           XCTAssertEqual(calculator.calculString, "1 - ")
       }
       
       // ExpressionHaveEnoughElements
       func testGivenNumberOne_WhenExpressionDontHaveEnoughElement_ThenAlertMessage() {
           calculator.tapNumberButton(numberText: "1")
           
           calculator.equal()
           
           XCTAssertEqual(calculator.calculString, "1")
       }
    
    // Test canAddOperator
    func testGivenNumberOne_ThenApplyAdditionTwoTimes_ThenGiveResultAlert() {
        calculator.tapNumberButton(numberText: "1")
        
        calculator.addition()
        calculator.addition()
        
        XCTAssertEqual(calculator.calculString, "1 + ")
    }
    
    //Minimum number
    func testGivenNumberOne_WhenHasEnoughMinimumNumber_ThenGiveAlert() {
        calculator.tapNumberButton(numberText: "1")
        
        

    }
    // Finish By operator
    
    func testGivenNumberOne_WhenDivideByTwo_ThenResultIsCorrect() {
        calculator.tapNumberButton(numberText: "1")
        
        calculator.division()
        calculator.tapNumberButton(numberText: "2")
        calculator.equal()
        
        XCTAssertEqual(calculator.calculString, "1 ÷ 2 = 0.5")
    }
    
    //MARK: TDD
    
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
