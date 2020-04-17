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

    func testAddOneNumber() {
        let calculator = CalculatorImplementation()
        
        calculator.add(number: 3)
        
        XCTAssertEqual(calculator.textToCompute, "3")


    }
    
}
