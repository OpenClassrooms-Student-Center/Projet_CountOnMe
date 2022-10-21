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
    
    var calculator = Calculator()

    override func setUp() {
        super.setUp()
        calculator = Calculator()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }


    // test expression correct
    func testGivenANumberAnOperationAndAnNumber_WhenGettingExpressionIsCorrect_ThenResultShouldBeTrue() {
        let elements = ["1", "+", "2"]
        let resultat = calculator.theExpressionIsCorrect(elements: elements)
        XCTAssertEqual(resultat, true)
    }
    
    // test expression a assez d'élement
    // test expression peut ajouter un élément
    // Je peux faire une addition
    // Je peux faire une soustraction
    // Je peux faire une multiplication
    // Je peux faire une division
    // Je ne peux pas avoir trop de chiffres
        
    
}
