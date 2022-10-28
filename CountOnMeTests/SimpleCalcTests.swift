//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
// swiftlint:disable line_length

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

    // test expression has enough element is incorrect
    func testGivenANumberAndAnOperation_WhenGettingExpressionhaveEnoughElement_ThenResultShouldBeFalse() {
        let elements = ["1", "+"]
        let result = calculator.theExpressionHaveEnoughElement(elements: elements)
        XCTAssertEqual(result, false)
    }

    // test expression has not enough element is incorrect
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

    // test expression has a result
    func testGivenAnOperationWithEqual_WhenGettingExpressionHaveResult_thenResultShouldBeTrue() {
        let element = "2+4=1"
        let result = calculator.theExpressionHaveResult(text: element)
        XCTAssertEqual(result, true)
    }

    // test expression has not a result
    func testGivenAnOperationWithoutEqual_WhenGettingExpressionHaveResult_thenResultShouldBeFalse() {
        let element = "2+4"
        let result = calculator.theExpressionHaveResult(text: element)
        XCTAssertEqual(result, false)
    }

    func testGivenANil_WhenGettingExpressionHaveResult_thenResultShouldBeFalse() {
        let element = ""
        let result = calculator.theExpressionHaveResult(text: element)
        XCTAssertEqual(result, false)
    }

    // test simple addition
    func testGivenANumber1AnAdditionAndANumber2_WhenGettingCalculate_ThenResultShouldBeThree() {
        let elements = ["1", "+", "2"]
        let result = calculator.calculate(operation: elements)
        XCTAssertEqual(result, "3")
    }

    // test simple addition
    func testGivenANumber1ASoustractionAndANumber2_WhenGettingCalculate_ThenResultShouldBeMinusOne() {
        let elements = ["1", "-", "2"]
        let result = calculator.calculate(operation: elements)
        XCTAssertEqual(result, "-1")
    }

    // test expression with addition and soustraction
    func testGivenAnAdditionAndASoustraction_WhenGettingCalculate_ThenResultShouldBeMinusOne() {
        let elements = ["1", "-", "2", "+", "5"]
        let result = calculator.calculate(operation: elements)
        XCTAssertEqual(result, "4")
    }

    // test expression simple multiplication
    func testGivenANumber5AMultiplicationAndANumber2_WhenGettingCalculate_ThenResultShouldBeTen() {
        let elements = ["5", "×", "2"]
        let result = calculator.calculate(operation: elements)
        XCTAssertEqual(result, "10")
    }

    // test expression simple division
    func testGivenANumber5ADivisionAndANumber2_WhenGettingCalculate_ThenResultShouldBeTwoPointFive() {
        let elements = ["5", "÷", "2"]
        let result = calculator.calculate(operation: elements)
        XCTAssertEqual(result, "2.5")
    }

    // test expression division by 0
    func testGivenANumber5ADivisionAndANumber0_WhenGettingCalculate_ThenResultShouldBeErreur() {
        let elements = ["5", "÷", "0"]
        let result = calculator.calculate(operation: elements)
        XCTAssertEqual(result, "Erreur")
    }

    // test priorisation of division operation
    func testGivenAnAdditionAndDivision_WhenGettingCalculate_ThenResultShouldBe2WithApriorisationOfADivision() {
        let elements = ["1", "+", "5", "÷", "5"]
        let result = calculator.calculate(operation: elements)
        XCTAssertEqual(result, "2")
    }

    // test with an addition, a multiplication and a division
    func testGivenAnMultipleOperation_WhenGettingCalculate_ThenResultShouldBe3Point5WithAprioOfMultiplicationThenDivision() {
        let elements = ["1", "+", "5", "×", "4", "÷", "8"]
        let result = calculator.calculate(operation: elements)
        XCTAssertEqual(result, "3.5")
    }

    // test an unknown operator in the multiplication/division
    func testGivenAUnknownOperatorInTheMultiplicationDivision_WhenGettingCalculate_ThenResultShouldBeErreur() {
        let elements = ["1", "x", "5", "×", "5"]
        let result = calculator.calculate(operation: elements)
        XCTAssertEqual(result, "Erreur")
    }

    // test an unknown operator in the addition
    func testGivenAUnknownOperatorInTheAddition_WhenGettingCalculate_ThenResultShouldBeErreur() {
        let elements = ["1", "x", "5", "+", "5"]
        let result = calculator.calculate(operation: elements)
        XCTAssertEqual(result, "Erreur")
    }

    // test of a long operation
    func testGivenALongOperation_WhenGettingCalculate_ThenResultShouldBe5() {
        let elements = ["1", "+", "5", "×", "4", "÷", "5", "-", "5", "+", "5", "×", "1"]
        let result = calculator.calculate(operation: elements)
        XCTAssertEqual(result, "5")
    }

    // test a long operation with a division by 0
    func testGivenALongOperationWithADivisionBy0_WhenGettingCalculte_ThenResultShouldBeErreur() {
        let elements = ["1", "+", "5", "×", "4", "÷", "5", "-", "5", "+", "5", "÷", "0"]
        let result = calculator.calculate(operation: elements)
        XCTAssertEqual(result, "Erreur")
    }

    // test a long operation with a multiplicatoin by 0
    func testGivenALongOperationWithAMultiplicationBy0_WhenGettingCalculte_ThenResultShouldBe5() {
        let elements = ["1", "+", "5", "×", "4", "÷", "5", "-", "5", "+", "5", "×", "0"]
        let result = calculator.calculate(operation: elements)
        XCTAssertEqual(result, "0")
    }
}
