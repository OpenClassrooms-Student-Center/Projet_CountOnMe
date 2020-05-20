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
    var simpleCalc: SimpleCalc!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        simpleCalc = SimpleCalc()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func initScreenResult(formula: [String]) {
        //cleaning screen
        simpleCalc.deleteElement(all: true)
        simpleCalc.formulaString = formula
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testGivenScreenResult_WhenDeleteElementIsSetToAll_ThenScreenDisplayIsZero() {
        simpleCalc.deleteElement(all: true)

       }
    
    func testGivenResultZero_WhenAddDigit1_ThenResultDisplay1() {
        initScreenResult(formula: ["0"])
        
        simpleCalc.addDigit(digitTxt: "1")
        print("test!1***\(simpleCalc.screenResult)")
        
        XCTAssertEqual(simpleCalc.screenResult, "1")
    }
    
    func testGivenResult1_WhenAddDigit1_ThenResultDisplay11() {
        initScreenResult(formula: ["1"])
        
        simpleCalc.addDigit(digitTxt: "1")
        print("test!1***\(simpleCalc.screenResult)")
        
        XCTAssertTrue(simpleCalc.screenResult == "11")
       }
    func testGivenResult12_WhenAddOperatorPlus_ThenResultDisplay_12Plus() {
           initScreenResult(formula: ["12"])
           
           simpleCalc.addOperator(operatorChar: "+")
           
           print("test!***\(simpleCalc.screenResult)")
           XCTAssertTrue(simpleCalc.screenResult == "12 +")
          }
    
    func testGivenResult12Plus12_WhenAddEqual_ThenResultDisplayEqual24() {
     initScreenResult(formula: ["12", "+", "12"])
     
     simpleCalc.getResult()
     print("test!***\(simpleCalc.screenResult)")
 
        XCTAssertEqual(simpleCalc.screenResult, "12 + 12 = 24 \n")
    }
    
    func testGivenFormula10Percent_WhenEqual_ThenResultDisplay0Comma1() {
        initScreenResult(formula: ["10", "%"])
    
        simpleCalc.getResult()
    
        XCTAssertEqual(simpleCalc.screenResult, "10 % = 0.1")
    }
}
