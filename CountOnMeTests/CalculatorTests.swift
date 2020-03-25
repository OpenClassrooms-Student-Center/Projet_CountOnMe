//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalculatorTests: XCTestCase {

    var calculator: Calculator!

    override func setUp() {
        super.setUp()
        calculator = Calculator()
    }

    // Check if clear
    func testGivenCalculSolved_WhenNumberTapped_ThenDisplayOnlyThisNumber() {
        calculator.operationStr = "2 + 3 = 5"

        calculator.addNumber("7")

        XCTAssert(calculator.operationStr == "7")
    }

    func testGivenCalculSolved_WhenClearTapped_ThenDisplayEmpty() {
        calculator.operationStr = "2 + 3 = 5"

        calculator.reset()

        XCTAssert(calculator.operationStr == "")
    }

    func testGivenCalculUnsolved_WhenClearTapped_ThenDisplayEmpty() {
        calculator.operationStr = "2 + 3"

        calculator.reset()

        XCTAssert(calculator.operationStr == "")
    }

    // MARK: - Operation

    func testGivenOperand_WhenAddOperatorAndOperand_ThenDisplayResult() {
        calculator.operationStr = "4"

        calculator.addOperator("+")
        calculator.addNumber("2")
        calculator.tappedEqual()

        XCTAssert(calculator.operationStr == "4 + 2 = 6")
    }

    func testGivenOperand_WhenAddInexistantOperator_ThenDisplayErrorMessage() {
        calculator.operationStr = "4"

        calculator.addOperator("!")

        XCTAssertEqual(calculator.operationStr, "4")
    }

    func testGivenAlreadyAdditionUnsolved_WhenMultiplication_ThenMultiplicationIsPrioritary() {
        calculator.operationStr = "4 + 6"

        calculator.addOperator("x")
        calculator.addNumber("2")
        calculator.tappedEqual()

        XCTAssert(calculator.operationStr == "4 + 6 x 2 = 16")
    }

    func testGivenAlreadyAdditionUnsolved_WhenDivision_ThenDivisionIsPrioritary() {
        calculator.operationStr = "4 + 6"

        calculator.addOperator("/")
        calculator.addNumber("2")
        calculator.tappedEqual()

        XCTAssert(calculator.operationStr == "4 + 6 / 2 = 7")
    }

    func testGivenNumberAndDivisionOperator_WhenDivisorNumberIs0_ThenDisplayErrorMessage() {
        calculator.operationStr = "4 / "

        calculator.addNumber("0")
        calculator.tappedEqual()

        XCTAssertEqual(calculator.operationStr, "")
    }

    func testGivenNumberAndSubstractionOperator_WhenSubstractedNumberGreater_ThenNegativeResult() {
        calculator.operationStr = "2 - "

        calculator.addNumber("4")
        calculator.tappedEqual()

        XCTAssert(calculator.operationStr == "2 - 4 = -2")
    }

    func testGivenDecimalNumber_WhenCommaButtonTappedAgain_ThenDisplayErrorMessage() {
        calculator.operationStr = "1.3"

//        expectation(forNotification: NSNotification.Name(rawValue: "error"), object: nil, handler: nil)
        calculator.addDecimal()

//        waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssert(calculator.operationStr == "1.3")
    }

    func testGivenMultiplicationWithTwoDecimalNumber_WhenEqualTapped_ThenResultIsCorrect() {
        calculator.operationStr = "1.3 x 2.7"

        calculator.tappedEqual()

        XCTAssert(calculator.operationStr == "1.3 x 2.7 = 3.51")
    }

    // MARK: - Syntax

    func testGivenNumberAndOperator_WhenOperatorTapped_ThenDisplayErrorMessage() {
        calculator.operationStr = "4 + "

        calculator.addOperator("-")

        XCTAssertEqual(calculator.operationStr, "4 + ")
    }

    func testOperationSolved_WhenOperatorTapped_ThenResultBecomeFirstOperand() {
        calculator.operationStr = "4 + 3 = 7 "

        calculator.addOperator("-")

        XCTAssert(calculator.operationStr == "7 - ")
    }

    func testGivenEmptyDisplay_WhenCommaButton_ThenDisplayErrorMessageAndAddZeroBeforeComma() {
        calculator.operationStr = ""

        calculator.addDecimal()

        XCTAssert(calculator.operationStr == "0.")
    }

    func testGivenNumberTapped_WhenCommaButton_ThenAddComma() {
        calculator.operationStr = "5"

        calculator.addDecimal()

        XCTAssert(calculator.operationStr == "5.")
    }

    func testGivenUnexactDivision_WhenEqualButtonTapped_ThenFormatResult() {
        calculator.operationStr = "7 / 3"

        calculator.tappedEqual()

        XCTAssert(calculator.operationStr == "7 / 3 = 2.33")
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
