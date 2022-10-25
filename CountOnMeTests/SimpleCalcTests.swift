//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.

import XCTest
@testable import CountOnMe

class SimpleCalcTests: XCTestCase {
    var calculator = Calculator()
    override func setUp() {
        super.setUp()
        calculator = Calculator()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    // test expression is correct
    func testGivenANumberAnOperationAndAnNumber_WhenGettingExpressionIsCorrect_ThenResultShouldBeTrue() {
        let elements = ["1", "+", "2"]
        let result = calculator.theExpressionIsCorrect(elements: elements)
        XCTAssertEqual(result, true)
    }

    // test expression is incorrect
    func testGivenANumberAndAnOperation_WhenGettingExpressionIsCorrect_ThenResultShouldBeFalse() {
        let elements = ["1", "+"]
        let result = calculator.theExpressionIsCorrect(elements: elements)
        XCTAssertEqual(result, false)
    }

    // test expression have enough element is incorrect
    func testGivenANumberAndAnOperation_WhenGettingExpressionhaveEnoughElement_ThenResultShouldBeFalse() {
        let elements = ["1", "+"]
        let result = calculator.theExpressionHaveEnoughElement(elements: elements)
        XCTAssertEqual(result, false)
    }

    // test expression have not enough element is incorrect
    func testGivenANumberAndAnOperation_WhenGettingExpressionhaveEnoughElement_ThenResultShouldBeTrue() {
        let elements = ["1", "+", "2"]
        let result = calculator.theExpressionHaveEnoughElement(elements: elements)
        XCTAssertEqual(result, true)
    }

    // test expression can add operator
    func testGivenANumber_WhenGettingExpressionCanAddOperator_ThenResultShouldBeTrue() {
        let elements = ["1"]
        let result = calculator.theExpressionCanAddOperator(elements: elements)
        XCTAssertEqual(result, true)
    }

    // test expression cannot add operator
    func testGivenANumber_WhenGettingExpressionCanAddOperator_ThenResultShouldBeFalse() {
        let elements = ["1", "+"]
        let result = calculator.theExpressionCanAddOperator(elements: elements)
        XCTAssertEqual(result, false)
    }

    // test simple addition
    func testGivenANumber1AnAdditionAndANumber2_WhenGettingCalculate_ThenResultShouldBeThree() {
        let elements = ["1", "+", "2"]
        let result = calculator.calculate(operation: elements)
        XCTAssertEqual(result, 3.0)
    }

    // test simple addition
    func testGivenANumber1ASoustractionAndANumber2_WhenGettingCalculate_ThenResultShouldBeMinusOne() {
        let elements = ["1", "-", "2"]
        let result = calculator.calculate(operation: elements)
        XCTAssertEqual(result, -1.0)
    }

    // test expression with addition and soustraction
    func testGivenAnAdditionAndASoustraction_WhenGettingCalculate_ThenResultShouldBeMinusOne() {
        let elements = ["1", "-", "2", "+", "5"]
        let result = calculator.calculate(operation: elements)
        XCTAssertEqual(result, 4.0)
    }

    func testGivenANumber5AMultiplicationAndANumber2_WhenGettingCalculate_ThenResultShouldBeTen() {
        let elements = ["5", "×", "2"]
        let result = calculator.calculate(operation: elements)
        XCTAssertEqual(result, 10.0)
    }

    func testGivenANumber5ADivisionAndANumber2_WhenGettingCalculate_ThenResultShouldBeTwoPointFive() {
        let elements = ["5", "÷", "2"]
        let result = calculator.calculate(operation: elements)
        XCTAssertEqual(result, 2.5)
    }
    // Je ne peux pas avoir trop de chiffres
}
