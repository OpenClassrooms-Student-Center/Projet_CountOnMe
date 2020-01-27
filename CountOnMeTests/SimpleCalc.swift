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
    
    var calculator: Calculator!

    
    override func setUp() {
        super.setUp()
        calculator = Calculator()
    }
    
    override func tearDown() {
        super.tearDown()
        calculator = nil
    }
    
    func testGivenAdditionCalcul_ThenApplyAdditionSign_ThenGiveResult() {
        calculator.tapNumberButton(numberText: "1")
        calculator.addition()
        calculator.tapNumberButton(numberText: "1")
        calculator.equal()
        XCTAssertEqual(calculator.calculString, "1 + 1 = 2")
    }
    
    
    func testGivenSubstractionCalcul_ThenApplyOperator_ThenGiveResult() {
     calculator.tapNumberButton(numberText: "1")
     calculator.substraction()
     calculator.tapNumberButton(numberText: "1")
     calculator.equal()
     XCTAssertEqual(calculator.calculString, "1 - 1 = 0")
    }
    
    func testGivenAdditionCalcul_ThenApplyAdditionSign_ThenGiveResultError() {
        calculator.tapNumberButton(numberText: "1")
        calculator.addition()
        calculator.addition()
        XCTAssertEqual(calculator.calculString, "1 + ")
    }
    
// =======  Éléments a tester  =============
    
//     var delegate: TranslateCalcul?
//
//     var elements: [String] { get }
//
//     var expressionIsCorrect: Bool { get }
//
//     var expressionHaveEnoughElement: Bool { get }
//
//     var canAddOperator: Bool { get }
//
//     var expressionHaveResult: Bool { get }
//
//     func equal()
//
//     func tapNumberButton(numberText: String)

   
}
