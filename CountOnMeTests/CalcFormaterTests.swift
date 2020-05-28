//
//  CalcFormatterTests.swift
//  CalcFormatterTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalcFormatterTests: XCTestCase {
   
    var formulaTxt: String = ""
    var screenResult: String = ""
    
    var calcFormatter: CalcFormatter!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        calcFormatter = CalcFormatter()
        calcFormatter.delegate = self
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func getTappedDigit(digit: String) {
        calcFormatter.addDigit(digitTxt: digit)
    }
    
    func getTappedOperator(calcOperator: String) {
        calcFormatter.addOperator(operatorChar: calcOperator)
    }
    
    func getTappedEqual() {
        calcFormatter.getResult()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGivenStarted_WhenDidNothing_ThenFormulaGive0() {
                
        XCTAssertEqual(formulaTxt, "0")
    }
    
    func testGivenStarted_WhenAddDigit1_ThenFormulaGive1() {
        
        getTappedDigit(digit: "1")
        
        XCTAssertEqual(formulaTxt, "1")
    }
    func testGivenResult12_WhenAddOperatorPlus_ThenResultDisplay_12Plus() {
        getTappedDigit(digit: "12")
        getTappedOperator(calcOperator: "+")
        
        print("test!***\(formulaTxt)")
        
        XCTAssertEqual(formulaTxt, "12 +")
    }
    
    func testGivenResult12Plus12_WhenAddEqual_ThenResultDisplayEqual24() {
        getTappedDigit(digit: "12")
        getTappedOperator(calcOperator: "+")
        getTappedDigit(digit: "12")
        
        getTappedEqual()
        
        XCTAssertEqual(formulaTxt, "12 + 12 = 24")
    }
    
    func testGiven0WhenOneTappedThenShouldShowOne() {
        calcFormatter.addDigit(digitTxt: "1")
        
        XCTAssertEqual(formulaTxt, "1")
    }
}
