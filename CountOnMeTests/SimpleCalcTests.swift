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
    var cleaner: CleanerImplementation!
    var calculatorDelegateMock: CalculatorDelegateMock!
    
    override func setUp() {
        super.setUp()
        cleaner = CleanerImplementation()
        calculatorDelegateMock = CalculatorDelegateMock()
        calculator = CalculatorImplementation(cleaner: cleaner, calculatorDelegateMock: calculatorDelegateMock)
    }

    //MARK: - Verify adding relative numbers in lhs and replace an operator with another

    func testGiventTextToComputeIsEmpty_WhenAddingRelativeNumbers_ThenTextToComputeContainsRelativeNumbers() {
        calculator.add(mathOperator: .minus)
        calculator.add(number: 111)
        
        XCTAssertEqual(calculator.calculatorDelegateMock?.operationString, "-111")
    }

    func testGivenTextToComputeHasRelativeSign_WhenAddingAnotherRelativeSign_ThenTextToComputeContainsTheOtherRelativeSign() {
        calculator.add(mathOperator: .plus)

        calculator.add(mathOperator: .minus)
    
        XCTAssertEqual(calculator.calculatorDelegateMock?.operationString, "-")
    }

    func testGivenTextToComputeHasLeftExpressionAndPlus_WhenAddingMinus_ThenTextToComputeContainsMinusInstead() {
        calculator.add(number: -111)
        calculator.add(mathOperator: .plus)
        
        calculator.add(mathOperator: .minus)
        
        XCTAssertEqual(calculator.calculatorDelegateMock?.operationString, "-111 - ")
    }

    //MARK: - Verify correctness of expression

    func testGivenTextToComputeIsEmptySoExpressionHasNotEnoughElement_WhenCalculate_ThenResultIsNil() {
        XCTAssertThrowsError(try calculator.calculate(), "explication 52") { (error) in
            let calculatorError = error as! CalculatorError
            XCTAssertEqual(calculatorError, CalculatorError.expressionIsIncomplete)
        }
    }

    func testGivenTextToComputeExpressionIsNotCorrect_WhenCalculate_ThenResultIsNil() {
        calculator.add(number: -111)
        calculator.add(mathOperator: .plus)

        XCTAssertThrowsError(try calculator.calculate(), "explication 62") { (error) in
            let calculationError = error as! CalculatorError
            XCTAssertEqual(calculationError, CalculatorError.expressionIsIncorrect)
        }
    }

    //MARK: - Verify correctness of result for each operator
    
    func testGivenTextToComputeHasCompleteExpressionOfAddidtion_WhenCalculate_ThenResultIs222() {
        addExpression(with: .plus)

        try? calculator.calculate()

        XCTAssertEqual(calculator.calculatorDelegateMock?.result, 222)
    }

    func testGivenTextToComputeHasCompleteExpressionOfSubstraction_WhenCalculate_ThenResultIs0() {
        addExpression(with: .minus)

        try? calculator.calculate()

        XCTAssertEqual(calculator.calculatorDelegateMock?.result, 0)
    }

    func testGivenTextToComputeHasCompleteExpressionOfMultiplication_WhenCalculate_ThenResultIs12321() {
        addExpression(with: .multiply)

        try? calculator.calculate()

        XCTAssertEqual(calculator.calculatorDelegateMock?.result, 12321)
    }

    func testGivenTextToComputeHasCompleteExpressionOfDivision_WhenCalculate_ThenResultIs1() {
        addExpression(with: .divide)

        try? calculator.calculate()

        XCTAssertEqual(calculator.calculatorDelegateMock?.result, 1)
    }

    //MARK: - Verify calculation priority rules and division by 0

    func testGivenTextToComputeHasCompleteExpressionOfAddidtionAndMultiplication_WhenCalculate_ThenResultIsTwoHundredSeventySevenPointFive() {
        addExpression(with: .plus)
        calculator.add(mathOperator: .multiply)
        calculator.add(number: 3)
        calculator.add(mathOperator: .divide)
        calculator.add(number: 2)
        try? calculator.calculate()

        XCTAssertEqual(calculator.calculatorDelegateMock?.result, 277.5)
    }

    func testGivenTextToComputeHasCompleteExpressionOfDisionBy0_WhenCalculate_ThenResultIsNil() {
        calculator.add(number: 12)
        calculator.add(mathOperator: .divide)
        calculator.add(number: 2)
        calculator.add(mathOperator: .divide)
        calculator.add(number: 0)

        XCTAssertThrowsError(try calculator.calculate(), "explication 110", { (error) in
            let calculatorError = error as! CalculatorError
            XCTAssertEqual(calculatorError, CalculatorError.cannotDivideByZero)
        })
    }

    //MARK: - Verify clearing

    func testGivenTextToComputeHasCompleteExpression_WhenClear_ThenTextToComputeHas1CharacterLess() {
        addExpression(with: .plus)

        cleaner.delegate?.clearString()

        XCTAssertEqual(calculator.calculatorDelegateMock?.operationString, "111 + 11")
    }

    func testGivenTextToComputeHasCompleteExpression_WhenClearAll_ThenTextToComputeIsEmpty() {
        addExpression(with: .plus)

        cleaner.delegate?.clearAllString()

        XCTAssertEqual(calculator.calculatorDelegateMock?.operationString, "")
        
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
