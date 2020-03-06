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
        calculator.addNumber("2")
        calculator.addition()
        calculator.addNumber("3")
        calculator.processCalcul()

        calculator.addNumber("7")

        XCTAssert(calculator.operationStr == "7")
    }

    func testGivenCalculSolved_WhenClearTapped_ThenDisplayEmpty() {
        calculator.addNumber("4")
        calculator.addition()
        calculator.addNumber("6")
        calculator.processCalcul()

        calculator.reset()

        XCTAssert(calculator.operationStr == "")
    }

    func testGivenCalculUnsolved_WhenClearTapped_ThenDisplayEmpty() {
        calculator.addNumber("2")
        calculator.addition()
        calculator.addNumber("3")

        calculator.reset()

        XCTAssert(calculator.operationStr == "")
    }

    // MARK: - Operation

    func testGivenAlreadyAdditionUnsolved_WhenMultiplication_ThenMultiplicationIsPrioritary() {
        calculator.addNumber("4")
        calculator.addition()
        calculator.addNumber("6")

        calculator.multiplication()
        calculator.addNumber("2")
        calculator.processCalcul()

        XCTAssert(calculator.operationStr == "4 + 6 x 2 = 16")
    }

    func testGivenAlreadyAdditionUnsolved_WhenDivision_ThenDivisionIsPrioritary() {
        calculator.addNumber("4")
        calculator.addition()
        calculator.addNumber("6")

        calculator.division()
        calculator.addNumber("2")
        calculator.processCalcul()

        XCTAssert(calculator.operationStr == "4 + 6 / 2 = 7")
    }

    func testGivenNumberAndDivisionOperator_WhenDivisorNumberIs0_ThenDisplayErrorMessage() {
        calculator.addNumber("4")
        calculator.division()

        calculator.addNumber("0")
        calculator.processCalcul()

    }

    func testGivenNumberAndSubstractionOperator_WhenSubstractedNumberGreater_ThenNegativeResult() {
        calculator.addNumber("2")
        calculator.substraction()

        calculator.addNumber("4")
        calculator.processCalcul()

        XCTAssert(calculator.operationStr == "2 - 4 = -2")
    }

    func testGivenMultiplicationWithTwoDecimalNumber_WhenEqualTapped_ThenResultIsCorrect() {
        calculator.addNumber("1,3")
        calculator.multiplication()
        calculator.addNumber("2,7")

        calculator.processCalcul()

        XCTAssert(calculator.operationStr == "1,3 x 2,7 = 3,51")
    }

    // MARK: - Syntax

    func testGivenEmptyDisplay_WhenOperatorTapped_ThenDisplayErrorMessage() {
        calculator.operationStr = ""

        calculator.addition()

        XCTAssert(calculator.operationStr == "Erreur")
    }

    func testGivenNumberAndOperator_WhenOperatorTapped_ThenConvertOldOperatorForLastTappedOne() {
        calculator.addNumber("4")
        calculator.addition()

        calculator.substraction()

        XCTAssert(calculator.operationStr == "4 - ")
    }

    func testGivenNumberAndOperator_WhenEqualTapped_ThenDisplayErrorMessage() {
        calculator.addNumber("4")
        calculator.addition()

        calculator.processCalcul()

        XCTAssert(calculator.operationStr == "Erreur")
//        let expect = NotificationExpectation(name: "error")
//        wait(for: [expect], timeout: 0.1)
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
