//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//
// swiftlint:disable force_try

import XCTest
@testable import CountOnMe

class CalculatorTests: XCTestCase {

    var calculator: Calculator!
    let calculatoreDelegateMockImplementation = CalculatoreDelegateMockImplementation()

    override func setUp() {
        super.setUp()
        calculator = Calculator()
        calculator.delegate = calculatoreDelegateMockImplementation
    }

    // Check if clear
    func testGivenCalculSolved_WhenNumberTapped_ThenDisplayOnlyThisNumber() {
        calculator.operationStr = "2 + 3 = 5"

        calculator.addNumber("7")

        XCTAssert(calculatoreDelegateMockImplementation.operationStr == "7")
    }

    func testGivenCalculSolved_WhenClearTapped_ThenDisplayEmpty() {
        calculator.operationStr = "2 + 3 = 5"

        calculator.reset()

        XCTAssert(calculatoreDelegateMockImplementation.operationStr == "")
    }

    func testGivenCalculUnsolved_WhenClearTapped_ThenDisplayEmpty() {
        calculator.operationStr = "2 + 3"

        calculator.reset()

        XCTAssert(calculatoreDelegateMockImplementation.operationStr == "")
    }

    // MARK: - Operation

    func testGivenNumber_WhenAddOperatorAndNumber_ThenDisplayResult() {
        calculator.operationStr = "4"

        try! calculator.addOperator(.plus)

        calculator.addNumber("2")

        try! calculator.resolveOperation()

        XCTAssert(calculatoreDelegateMockImplementation.operationStr == "6")
    }

    func testGivenAlreadyAdditionUnsolved_WhenMultiplication_ThenMultiplicationIsPrioritary() {
        calculator.operationStr = "4 + 6"

        try! calculator.addOperator(.multiply)

        calculator.addNumber("2")

        try! calculator.resolveOperation()

        XCTAssert(calculatoreDelegateMockImplementation.operationStr == "16")
    }

    func testGivenAlreadyAdditionUnsolved_WhenDivision_ThenDivisionIsPrioritary() {
        calculator.operationStr = "4 + 6"

        try! calculator.addOperator(.divide)
        calculator.addNumber("2")

        try! calculator.resolveOperation()

        XCTAssert(calculatoreDelegateMockImplementation.operationStr == "7")
    }

    func testGivenNumberAndDivisionOperator_WhenDivisorNumberIs0_ThenDisplayErrorMessage() {
        calculator.operationStr = "4 / "

        calculator.addNumber("0")
        XCTAssertThrowsError(try calculator.resolveOperation()) { error in
            XCTAssertEqual(error as? CalculatorError, CalculatorError.expressionIsNotCorrect)

        }

        XCTAssertEqual(calculator.operationStr, "4 / 0")
    }

    func testGivenNumberAndSubstractionOperator_WhenSubstractedNumberGreater_ThenNegativeResult() {
        calculator.operationStr = "2 - "

        calculator.addNumber("4")

        try! calculator.resolveOperation()

        XCTAssert(calculatoreDelegateMockImplementation.operationStr == "-2")
    }

    func testGivenDecimalNumber_WhenCommaButtonTappedAgain_ThenDisplayErrorMessage() {
        calculator.operationStr = "1.3"

        XCTAssertThrowsError(try calculator.addDecimal()) { error in
            XCTAssertEqual(error as? CalculatorError, CalculatorError.expressionIsNotCorrect)
        }

        XCTAssert(calculatoreDelegateMockImplementation.operationStr == "1.3")
    }

    func testGivenMultiplicationWithTwoDecimalNumber_WhenEqualTapped_ThenResultIsCorrect() {
        calculator.operationStr = "1.3 x 2.7"

        try! calculator.resolveOperation()

        XCTAssert(calculatoreDelegateMockImplementation.operationStr == "3.51")
    }

    // MARK: - Syntax

    func testGivenAlreadyAnOperator_WhenOperatorAdd_ThenDisplayErrorMessage() {
        calculator.operationStr = "4 + "

        XCTAssertThrowsError(try calculator.addOperator(.minus)) { error in
            XCTAssertEqual(error as? CalculatorError, CalculatorError.anOperatorIsAlreadyPresent)
        }
    }

    func testOperationSolved_WhenOperatorTapped_ThenResultBecomeFirstNumber() {
        calculator.operationStr = "4 + 3 = 7 "

        try! calculator.addOperator(.minus)

        XCTAssert(calculatoreDelegateMockImplementation.operationStr == "7 - ")
    }

    func testGivenEmptyDisplay_WhenCommaButton_ThenDisplayErrorMessageAndAddZeroBeforeComma() {
        calculator.operationStr = ""

        try! calculator.addDecimal()

        XCTAssert(calculatoreDelegateMockImplementation.operationStr == "0.")
    }

    func testGivenNumberTapped_WhenCommaButton_ThenAddComma() {
        calculator.operationStr = "5"

        try! calculator.addDecimal()

        XCTAssert(calculatoreDelegateMockImplementation.operationStr == "5.")
    }

    func testGivenUnexactDivision_WhenEqualButtonTapped_ThenFormatResult() {
        calculator.operationStr = "7 / 3"

            try! calculator.resolveOperation()

        XCTAssert(calculatoreDelegateMockImplementation.operationStr == "2.33")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
