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

    //MARK: - Verify adding relative numbers in lhs and replace an operator with another

    func testGiventTextToComputeIsEmpty_WhenAddingRelativeNumbers_ThenTextToComputeContainsRelativeNumbers() {
        calculator.add(mathOperator: .minus)
        calculator.add(number: 111)
        
        XCTAssertEqual(calculator.textToCompute, "-111")
    }

    func testGivenTextToComputeHasLeftExpressionAndPlus_WhenAddingMinus_ThenTextToComputeContainsMinusInstead() {
        calculator.add(number: -111)
        calculator.add(mathOperator: .plus)
        
        calculator.add(mathOperator: .minus)
        
        XCTAssertEqual(calculator.textToCompute, "-111 - ")
    }

    //MARK: - Verify correctness of expression

    func testGivenTextToComputeIsEmptySoExpressionHasNotEnoughElement_WhenCalculate_ThenResultIsNil() {
        XCTAssertNil(calculator.calculate())
    }

    func testGivenTextToComputeExpressionIsNotCorrect_WhenCalculate_ThenResultIsNil() {
        calculator.add(number: -111)
        calculator.add(mathOperator: .plus)

        XCTAssertNil(calculator.calculate())
    }

    //MARK: - Verify correctness of result for each operator
    
    func testGivenTextToComputeHasCompleteExpressionOfAddidtion_WhenCalculate_ThenResultIs222() {
        addExpression(with: .plus)

        XCTAssertEqual(calculator.calculate(), 222)
    }

    func testGivenTextToComputeHasCompleteExpressionOfSubstraction_WhenCalculate_ThenResultIs0() {
        addExpression(with: .minus)

        XCTAssertEqual(calculator.calculate(), 0)
    }

    func testGivenTextToComputeHasCompleteExpressionOfMultiplication_WhenCalculate_ThenResultIs0() {
        addExpression(with: .multiply)

        XCTAssertEqual(calculator.calculate(), 12321)
    }

    func testGivenTextToComputeHasCompleteExpressionOfDivision_WhenCalculate_ThenResultIs0() {
        addExpression(with: .divide)

        XCTAssertEqual(calculator.calculate(), 1)
    }

    //MARK: - Verify calculation priority rules and division by 0

    func testGivenTextToComputeHasCompleteExpressionOfAddidtionAndMultiplication_WhenCalculate_ThenResultIsTwoHundredSeventySevenPointFive() {
        addExpression(with: .plus)
        calculator.add(mathOperator: .multiply)
        calculator.add(number: 3)
        calculator.add(mathOperator: .divide)
        calculator.add(number: 2)
        
        XCTAssertEqual(calculator.calculate(), 277.5)
    }

    func testGivenTextToComputeHasCompleteExpressionOfDisionBy0_WhenCalculate_ThenResultIsNil() {
        calculator.add(number: 12)
        calculator.add(mathOperator: .divide)
        calculator.add(number: 2)
        calculator.add(mathOperator: .divide)
        calculator.add(number: 0)

        XCTAssertNil(calculator.calculate())
    }

    //MARK: - Verify clearing

    func testGivenTextToComputeHasCompleteExpression_WhenClear_ThenTextToComputeHas1CharacterLess() {
        addExpression(with: .plus)

        calculator.clearTextToCompute()

        XCTAssertEqual(calculator.textToCompute, "111 + 11")
    }

    func testGivenTextToComputeHasCompleteExpression_WhenClearAll_ThenTextToComputeIsEmpty() {
        addExpression(with: .plus)

        calculator.clearAllTextToCompute()

        XCTAssertEqual(calculator.textToCompute, "")
        
    }

    //MARK: - Tools
    
    private func addExpression(with mathOperator: MathOperator) {
        calculator.add(number: 111)
        calculator.add(mathOperator: mathOperator)
        calculator.add(number: 111)
    }

//   private func addPieceOfExpression(mathOperator: MathOperator, number: Int)() {
//        calculator.add(mathOperator: mathOperator)
//        calculator.add(number: number)
//    }
}
