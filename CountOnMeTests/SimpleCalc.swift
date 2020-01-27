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
    
    
    func testGivenSubstractionCalcul_ThenApplySubstractionSign_ThenGiveResultError() {
        calculator.tapNumberButton(numberText: "1")
        calculator.substraction()
        calculator.substraction()
        XCTAssertEqual(calculator.calculString, "1 - ")
    }
    
    func testGiven_When_Then() {
        calculator.tapNumberButton(numberText: "1")
        calculator.substraction()
        calculator.substraction()
    }
    
    func testGiven_When_Then2() {

    }
    
//    func equal() {
//           guard expressionIsCorrect else {
//               delegate?.displayAlert(message: "Entrez une expression correcte !")
//               return
//           }
//
//           guard expressionHaveEnoughElement else {
//               delegate?.displayAlert(message: "Demarrez un nouveau calcul !")
//               return
//           }
    

    
}
