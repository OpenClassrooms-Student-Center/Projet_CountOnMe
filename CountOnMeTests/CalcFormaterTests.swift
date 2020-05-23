//
//  CalcFormaterTests.swift
//  CalcFormaterTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalcFormaterTests: XCTestCase {
    
    var calcFormater: CalcFormater!
    weak var calcFormaterDelegateTest: CalcFormaterDelegateTest?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        calcFormater = CalcFormater()
        self.calcFormaterDelegateTest = self
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func getTappedDigit(digit: String) {
        calcFormater.addDigit(digitTxt: digit)
    }
    
    func getTappedOperator(calcOperator: String) {
        calcFormater.addOperator(operatorChar: calcOperator)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGivenResultZero_WhenGetTappedDigit1_ThenShowOne() {
        initScreenResult(formula: ["0"])
        
        calcFormater.addDigit(digitTxt: "1")
        print("test!1***\(calcFormater.screenResult)")
        
        XCTAssertEqual(calcFormater.screenResult, "1")
    }
    
    func testGiven1_WhenAddDigit1_ThenShow1() {
        getTappedDigit(digit: "1")
        
        getTappedDigit(digit: "1")
        
        print("test!1***\(calcFormater.screenResult)")
        
        XCTAssertTrue(calcFormater.screenResult == "11")
    }
    func testGivenResult12_WhenAddOperatorPlus_ThenResultDisplay_12Plus() {
        initScreenResult(formula: ["12"])
        
        calcFormater.addOperator(operatorChar: "+")
        print("test!***\(calcFormater.screenResult)")
        
        XCTAssertTrue(calcFormater.screenResult == "12 +")
    }
    
    func testGivenResult12Plus12_WhenAddEqual_ThenResultDisplayEqual24() {
        getTappedDigit(digit: "12")
        getTappedOperator(calcOperator: "+")
        getTappedDigit(digit: "12")
        
        calcFormater.getResult()
        print("test!***\(calcFormater.screenResult)")
        
        XCTAssertEqual(calcFormater.screenResult, "12 + 12 = 24 \n")
    }
    
    func testGivenFormula10Percent_WhenEqual_ThenResultDisplay0Comma1() {
        getTappedDigit(digit: "12")
        ®getTappedOperator(calcOperator: "%")
        
        calcFormater.getResult()
        
        XCTAssertEqual(calcFormater.screenResult, "10 % = 0.1")
    }
    func testGiven0WhenOneTappedThenShouldShowOne() {
        let calcFormater = CalcFormater()
        calcFormater.addDigit(digitTxt: "1")
        
        let result = calcFormaterDelegateTest?.getCalcFormaterDisplay()
        XCTAssertEqual(result, "1")
    }
}
