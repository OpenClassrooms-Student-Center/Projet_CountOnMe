//
//  CountOnMeTests.swift
//  CountOnMeTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CountOnMeTests: XCTestCase {
  let expression = Expression()
  let defaultExpression = "0"
  let expectedResultOf9Elements = "0.6"
  let expectedResultOfDivisionBy0 = Lexical.undefined
  let expressionOf7ElementsEndedByANumber = "1 + 2 - 3 × 4"
  let expressionOf8ElementsEndedByAnOperator = "1 + 2 - 3 × 4 / "
  let expressionOf9ElementsEndedByANumber = "1 + 2 - 3 × 4 / 5"
  let expressionWithDivisionBy0 = "1 / 0"
  let expressionWithResult = "1 + 2 - 3 × 4 / 5 = 0.6"
  let newExpression = "0.6 + "
  let numberToAdd = "5"
  let otherDefaultExpression = "713705" // to test convenience init
  let unfinishedExpression1 = "1 + "
  let unfinishedExpression2 = "1 - "
  let voidExpression = ""

  override func setUp() {
    super.setUp()
  }

  func testGivenExpression_WhenTryingToAddAnOperator_ThenCheckIfPossibleOrNot() {
    expression.entered = expressionOf9ElementsEndedByANumber
    XCTAssertTrue(expression.canAddOperator)

    expression.entered = expressionOf8ElementsEndedByAnOperator
    XCTAssertFalse(expression.canAddOperator)
  }

  func testGivenExpression_WhenReadingFirstElement_ThenCheckingIfItIs0() {
    expression.entered = defaultExpression
    XCTAssertTrue(expression.firstNumberIs0)
    expression.entered = expressionOf9ElementsEndedByANumber
    XCTAssertFalse(expression.firstNumberIs0)
  }

  func testGivenExpression_WhenReadingIt_ThenCheckingIfItHasResult() {
    expression.entered = defaultExpression
    XCTAssertFalse(expression.hasResult)
    expression.entered = expressionWithResult
    XCTAssertTrue(expression.hasResult)
  }

  func testGivenElements_WhenCountingTheNumber_ThenReturnsIfHasEnoughElementsOrNot() {
    expression.entered = expressionOf9ElementsEndedByANumber
    XCTAssertTrue(expression.hasEnoughElement)
    expression.entered = defaultExpression
    XCTAssertFalse(expression.hasEnoughElement)
  }

  func testGivenExpression_WhenReducingOperations_ThenGetExpectedResult() {
    expression.entered = expressionOf9ElementsEndedByANumber
    let calculatedResult = expression.operationsToReduce[0]
    XCTAssertEqual(calculatedResult, expectedResultOf9Elements)
  }

  func testGivenVoidExpression_WhenReducingOperations_ThenGetExpectedResult() {
    expression.entered = voidExpression
    let result = expression.operationsToReduce
    XCTAssertNil(result.first)
  }

  func testGivenExpressionWithDivisionBy0_WhenReducingOperations_ThenResultShouldBeUndefined() {
    expression.entered = expressionWithDivisionBy0
    let calculatedResult = expression.operationsToReduce[0]
    XCTAssertEqual(calculatedResult, expectedResultOfDivisionBy0)
  }

  func testGivenDefaultExpression_WhenDeclaringObject_ThenInstantiateWithNewDefaultValue() {
    let expression1 = expression
    let expression2 = Expression(otherDefaultExpression)
    XCTAssertNotEqual(expression1.entered, expression2.entered)
  }

  func testGivenExpression_WhenAddingANumber_ThenHaving1MoreElement() {
    expression.entered = expressionOf8ElementsEndedByAnOperator
    expression.addNumber(numberToAdd)
    XCTAssertEqual(expression.entered, expressionOf9ElementsEndedByANumber)
  }

  func testGivenExpression_WhenBeginWithDefaultExpression_ThenClearIt() {
    expression.entered = expressionWithResult
    expression.addNumber(numberToAdd)
    XCTAssertEqual(expression.entered, numberToAdd)
  }

  func testGivenExpression_WhenAddingANumberAndAlreadyHaveAResult_ThenAllClear() {
    expression.result = otherDefaultExpression
    expression.addNumber(numberToAdd)
    XCTAssertEqual(expression.entered, numberToAdd)
  }

  func testGivenExpression_WhenAddingAnOperatorAndAlreadyHaveAResult_ThenAllClear() {
    expression.entered = expressionWithResult
    expression.result = expectedResultOf9Elements
    expression.addOperator(.addition)
    XCTAssertEqual(expression.entered, newExpression)
  }

  func testGivenExpressionEndedByOperator_WhenChoosingAnotherOperator_ThenChangeIt() {
    expression.entered = unfinishedExpression1
    expression.addOperator(.substraction)
    XCTAssertEqual(expression.entered, unfinishedExpression2)
  }

  func testGivenExpression_WhenAddingAnOperator_ThenHaving1MoreElement() {
    expression.entered = expressionOf7ElementsEndedByANumber
    expression.addOperator(.division)
    XCTAssertEqual(expression.entered, expressionOf8ElementsEndedByAnOperator)
  }

  func testGivenExpression_WhenAllClear_ThenExpressionIsReinitialized() {
    expression.entered = expressionOf9ElementsEndedByANumber
    expression.allClear()
    XCTAssertEqual(expression.entered, defaultExpression)
  }

  func testGivenExpression_WhenCalculating_ThenCheckIfExpressionIsCorrect() {
    expression.entered = expressionOf9ElementsEndedByANumber
    expression.calculate()
    XCTAssertEqual(expression.result, expectedResultOf9Elements)
    expression.entered = unfinishedExpression1
    expression.calculate()
    XCTAssertEqual(expression.result, expectedResultOf9Elements)
  }

  func testGivenExpression_WhenClear_ThenLastElementIsDropped() {
    expression.entered = expressionOf9ElementsEndedByANumber
    expression.clear()
    XCTAssertEqual(expression.entered, expressionOf8ElementsEndedByAnOperator)
    expression.clear(forced: true)
    XCTAssertEqual(expression.entered, expressionOf7ElementsEndedByANumber)
  }
}
