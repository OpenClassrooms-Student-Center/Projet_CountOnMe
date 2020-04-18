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
    var calculator: CalculatorImplementation!
    
    override func setUp() {
        super.setUp()
        calculator = CalculatorImplementation()
    }

//    func testGivenTextToComputeIsEmpty_WhenAddingNumbers_ThenTextToComputeContainsNumbers() {
//        calculator.add(number: 111)
//        
//        XCTAssertEqual(calculator!.textToCompute, "111")
//    }

    func testGiventTextToComputeIsEmpty_WhenAddingRelativeNumbers_ThenTextToComputeContainsRelativeNumbers() {
        calculator.add(mathOperator: .minus)
        calculator.add(number: 111)
        
        XCTAssertEqual(calculator!.textToCompute, "-111")
    }

//    func testGivenTextToComputeHasLeftExpression_WhenAddingPlus_ThenTextToComputeContainsAlsoPlus() {
//        calculator.add(number: -111)
//        
//        calculator.add(mathOperator: .plus)
//        
//        XCTAssertEqual(calculator.textToCompute, "-111 + ")
//    }

    func testGivenTextToComputeHasLeftExpressionAndPlus_WhenAddingMinus_ThenTextToComputeContainsMinusInstead() {
        calculator.add(number: -111)
        calculator.add(mathOperator: .plus)
        
        calculator.add(mathOperator: .minus)
        
        XCTAssertEqual(calculator.textToCompute, "-111 - ")
    }

    func testGivenTextToComputeHasCompleteExpressionOfAddidtion_WhenCalculate_ThenResultIs0() {
        calculator.add(number: -111)
        calculator.add(mathOperator: .plus)
        calculator.add(number: 111)

        XCTAssertEqual(calculator.calculate(), 0)
    }

    func testGivenTextToComputeHasCompleteExpressionOfSubstraction_WhenCalculate_ThenResultIs0() {
        calculator.add(number: 111)
        calculator.add(mathOperator: .minus)
        calculator.add(number: 111)

        XCTAssertEqual(calculator.calculate(), 0)
    }

    func testGivenTextToComputeIsEmptySoExpressionHasNotEnoughElement_WhenCalculate_ThenResultIsNil() {
        XCTAssertNil(calculator.calculate())
    }

    func testGivenTextToComputeExpressionIsNotCorrect_WhenCalculate_ThenResultIsNil() {
        calculator.add(number: -111)
        calculator.add(mathOperator: .plus)

        XCTAssertNil(calculator.calculate())
    }
}
