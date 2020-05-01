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
        calculator = CalculatorImplementation()
        calculator.delegate = calculatorDelegateMock
    }

    // MARK: - Verify adding relative numbers in lhs and replace an operator with another

    func testGiventTextToComputeIsEmpty_WhenAddingRelativeNumbers_ThenTextToComputeContainsRelativeNumbers() {
        calculator.add(mathOperator: .minus)
        calculator.add(number: 111)

        checkOperationStringEqualsTo("-111")
    }

    func testGivenTextToComputeHasPositiveSign_WhenAddingNegativeSign_ThenTextToComputeContainsNegativeSign() {
        calculator.add(mathOperator: .plus)

        calculator.add(mathOperator: .minus)

        checkOperationStringEqualsTo("-")
    }

    func testGivenTextToComputeHasLeftExpressionAndPlus_WhenAddingMinus_ThenTextToComputeContainsMinusInstead() {
        calculator.add(number: -111)
        calculator.add(mathOperator: .plus)

        calculator.add(mathOperator: .minus)

        checkOperationStringEqualsTo("-111 - ")
    }

    // MARK: - Verify cannot add unnecessary 0

    func testGivenTextToComputeIsEmpty_WhenAdding0_ThenTextToComputeRemainsEmpty() {
        calculator.add(number: 0)

        checkOperationStringEqualsTo("")
    }

    func testGivenTextToComputeHasRelativeSign_WhenAdding0_ThenTextTocomputeRemainsEmpty() {
        calculator.add(mathOperator: .minus)

        calculator.add(number: 0)

        checkOperationStringEqualsTo("-")
    }

    func testGivenTextToComputeHasIncompleteExpression_WhenAdding0_ThenTextTocomputeRemainsUnchanged() {
        calculator.add(number: 1)
        calculator.add(mathOperator: .divide)

        calculator.add(number: 0)

        checkOperationStringEqualsTo("1 ÷ ")
    }

    // MARK: - Verify validity of expression

    func testGivenTextToComputeIsEmpty_WhenCalculate_ThenThrowsErrorIncomplete() {
        try? checkCalculatorError(.expressionIsIncomplete)
    }

    func testGivenTextToComputeExpressionIsNotCorrect_WhenCalculate_ThenThrowsErrorIncorrect() {
        calculator.add(number: -111)
        calculator.add(mathOperator: .plus)

        try? checkCalculatorError(.expressionIsIncorrect)
    }

    func testGivenTextToComputeHasResult_WhenCalculateAgain_ThenAndThrowsErrorEqualSignFound() {
        addExpression(with: .plus)
        try? calculator.calculate()

        try? checkCalculatorError(.equalSignFound)
    }

    // MARK: - Verify correctness of result for each operator

    func testGivenTextToComputeHasCompleteExpressionOfAddidtion_WhenCalculate_ThenResultIs222() {
        addExpression(with: .plus)

        try? calculator.calculate()

        checkOperationStringEqualsTo("111 + 111 = 222")
    }

    func testGivenTextToComputeHasCompleteExpressionOfSubstraction_WhenCalculate_ThenResultIs0() {
        addExpression(with: .minus)

        try? calculator.calculate()

        checkOperationStringEqualsTo("111 - 111 = 0")
    }

    func testGivenTextToComputeHasCompleteExpressionOfMultiplication_WhenCalculate_ThenResultIs12321() {
        addExpression(with: .multiply)

        try? calculator.calculate()

        checkOperationStringEqualsTo("111 × 111 = 12,321")
    }

    func testGivenTextToComputeHasCompleteExpressionOfDivision_WhenCalculate_ThenResultIs1() {
        addExpression(with: .divide)

        try? calculator.calculate()

        checkOperationStringEqualsTo("111 ÷ 111 = 1")
    }

    // MARK: - Verify calculation priority rules

    func testGivenTextToComputeHasCompleteExpressionOfAddidtionAndMultiplication_WhenCalculate_ThenResultIs277Point5() {
        addExpression(with: .plus)
        calculator.add(mathOperator: .multiply)
        calculator.add(number: 3)
        calculator.add(mathOperator: .divide)
        calculator.add(number: 2)
        try? calculator.calculate()

        checkOperationStringEqualsTo("111 + 111 × 3 ÷ 2 = 277.5")
    }

    // MARK: - Verify clearing

    func testGivenTextToComputeHasCompleteExpression_WhenClear_ThenTextToComputeHas1CharacterLess() {
        addExpression(with: .plus)

        calculator.deleteLastElement()

        checkOperationStringEqualsTo("111 + 11")
    }

    func testGivenTextToComputeIsIncorrect_WhenClear_ThenTextToComputeHasMathOperatorLess() {
        calculator.add(number: 1)
        calculator.add(mathOperator: .plus)

        calculator.deleteLastElement()

        checkOperationStringEqualsTo("1")
    }

    func testGivenTextToComputeHasResult_WhenClear_ThenTextToComputeIsEmpty() {
        addExpression(with: .plus)
        try? calculator.calculate()

        calculator.deleteLastElement()

        checkOperationStringEqualsTo("")
    }

    func testGivenTextToComputeHasCompleteExpression_WhenClearAll_ThenTextToComputeIsEmpty() {
        addExpression(with: .plus)

        calculator.deleteAllElements()

        checkOperationStringEqualsTo("")
    }

    // MARK: - Verify textToCompute is reset when it has result

    func testGivenTextToComputeHasResult_WhenAddingNumber_ThenTextToComputeContainsNumber() {
        addExpression(with: .plus)
        try? calculator.calculate()

        calculator.add(number: 1)

        checkOperationStringEqualsTo("1")
    }

    func testGivenTextToComputeHasResult_WhenAddingRelativeSign_ThenTextToComputeContainsRelativeSign() {
        addExpression(with: .plus)
        try? calculator.calculate()

        calculator.add(mathOperator: .minus)

        checkOperationStringEqualsTo("-")
    }

    func testGivenTextToComputeHasResult_WhenAddingWrongOperator_ThenTextToComputeIsEmpty() {
        addExpression(with: .plus)
        try? calculator.calculate()

        calculator.add(mathOperator: .divide)

        checkOperationStringEqualsTo("")
    }

    // MARK: - Tools

    private func addExpression(with mathOperator: MathOperator) {
        calculator.add(number: 111)
        calculator.add(mathOperator: mathOperator)
        calculator.add(number: 111)
    }

    private func checkOperationStringEqualsTo(_ string: String) {
        XCTAssertEqual(calculatorDelegateMock.operationString, string)
    }

    private func checkCalculatorError(_ err: CalculatorError) throws {
        XCTAssertThrowsError(try calculator.calculate(), "cannot calculate") { (error) in
            let calculatorError = error as? CalculatorError
            XCTAssertEqual(calculatorError, err)
        }
    }
}
