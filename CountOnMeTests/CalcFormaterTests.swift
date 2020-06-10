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
    var calcFormatter: CalcFormatter!
    var didErrorDivByZero: Bool = false
    var didErrorFormula: Bool = false
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        calcFormatter = CalcFormatter()
        calcFormatter.delegate = self
        calcFormatter.numberFormatter.groupingSeparator = " "
        calcFormatter.numberFormatter.decimalSeparator = ","
        
        var name = Notification.Name(rawValue: "CarryOutError")
        NotificationCenter.default.addObserver(self, selector: #selector(carryOutError), name: name, object: nil)
        
        name = Notification.Name(rawValue: "DivByZeroError")
        NotificationCenter.default.addObserver(self, selector: #selector(divByZeroError), name: name, object: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @objc func carryOutError() {
        didErrorFormula = true
    }
    
    @objc func divByZeroError() {
        didErrorDivByZero = true
    }
    
    func getTappedDigit(digit: String) {
        calcFormatter.addDigit(digitTxt: digit)
    }
    
    func getTappedOperator(calcOperator: String) {
        calcFormatter.addOperator(operatorChar: calcOperator)
    }
    
    func getTappedComma() {
        calcFormatter.addComma()
    }
    
    func getTappedReverse() {
        calcFormatter.reverseFigure()
    }
    
    func getTappedEqual() {
        calcFormatter.addEqual()
    }
    
    func getTappedCButton() {
        calcFormatter.deleteElement(all: false)
    }
    
    func getTappedACButton() {
        calcFormatter.deleteElement(all: true)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    /// test display of an addition on screen
    func testGiven12Plus12_WhenAddEqual_ThenResultDisplayEqual24() {
        getTappedDigit(digit: "1")
        getTappedDigit(digit: "2")
        getTappedOperator(calcOperator: "+")
        getTappedDigit(digit: "1")
        getTappedDigit(digit: "2")
        
        getTappedEqual()
        
        XCTAssertEqual(formulaTxt, "12 + 12 = 24")
    }
    
    /// test display of a soustraction on screen
    func testGiven24Minus12_WhenAddEqual_ThenResultDisplayEqual12() {
        getTappedDigit(digit: "2")
        getTappedDigit(digit: "4")
        getTappedOperator(calcOperator: "-")
        getTappedDigit(digit: "1")
        getTappedDigit(digit: "2")
        
        getTappedEqual()
        
        XCTAssertEqual(formulaTxt, "24 - 12 = 12")
    }
    
    /// test display of a multiplication on screen
    func testGiven24Mult2_WhenAddEqual_ThenResultDisplayEqual48() {
        getTappedDigit(digit: "2")
        getTappedDigit(digit: "4")
        getTappedOperator(calcOperator: "x")
        getTappedDigit(digit: "2")
        
        getTappedEqual()
        
        XCTAssertEqual(formulaTxt, "24 x 2 = 48")
    }
    
    /// test display of a division on screen
    func testGivenResult24Div2_WhenAddEqual_ThenResultDisplayEqual12() {
        getTappedDigit(digit: "2")
        getTappedDigit(digit: "4")
        getTappedOperator(calcOperator: "/")
        getTappedDigit(digit: "2")
        
        getTappedEqual()
        
        XCTAssertEqual(formulaTxt, "24 / 2 = 12")
    }
    
    /// test display a division with a float as result
    func testGiven24Div5_WhenAddEqual_ThenResultDisplayFloatResult() {
        getTappedDigit(digit: "24")
        getTappedOperator(calcOperator: "/")
        getTappedDigit(digit: "5")
        
        getTappedEqual()
        
        XCTAssertEqual(formulaTxt, "24 / 5 = 4,8")
    }
    
    ///test display a soustration  with float figure and zero after comma
    func testGiven24Comma05Minus5_WhenAddEqual_ThenDisplayFormulaWithResult() {
        getTappedDigit(digit: "2")
        getTappedDigit(digit: "4")
        getTappedComma()
        getTappedDigit(digit: "0")
        getTappedDigit(digit: "5")
        
        getTappedOperator(calcOperator: "-")
        getTappedDigit(digit: "5")
        
        getTappedEqual()
        
        XCTAssertEqual(formulaTxt, "24,05 - 5 = 19,05")
    }
    
    //test Multiplication with thousand separator
    func testGiven2450Mult1234_WhenAddEqual_ThenResultDisplay3023300() {
        getTappedDigit(digit: "2")
        getTappedDigit(digit: "4")
        getTappedDigit(digit: "5")
        getTappedDigit(digit: "0")
        getTappedOperator(calcOperator: "x")
        getTappedDigit(digit: "1")
        getTappedDigit(digit: "2")
        getTappedDigit(digit: "3")
        getTappedDigit(digit: "4")
        
        getTappedEqual()
        
        XCTAssertEqual(formulaTxt, "2 450 x 1 234 = 3 023 300")
    }
    
    ///test display Multiplication with float Values
    func testGiven24Comma5Mult5Comma5_WhenAddEqual_ThenResultDisplayResult() {
        getTappedDigit(digit: "2")
        getTappedDigit(digit: "4")
        getTappedComma()
        getTappedDigit(digit: "5")
        
        getTappedOperator(calcOperator: "x")
        getTappedDigit(digit: "5")
        getTappedComma()
        getTappedDigit(digit: "5")
        
        getTappedEqual()
        
        XCTAssertEqual(formulaTxt, "24,5 x 5,5 = 134,75")
    }
    
    ///test the reverse button +/-
    func testGiven24_WhenReverseButtonTapped_ThenResultDisplayMinus24() {
        getTappedDigit(digit: "2")
        getTappedDigit(digit: "4")
        
        getTappedReverse()
        
        XCTAssertEqual(formulaTxt, "-24")
    }
    
    ///test C button to delete last tapped figure
    func testGiven24Div10_WhenTappedCButton_ThenResultDisplayEqual24Div() {
        getTappedDigit(digit: "2")
        getTappedDigit(digit: "4")
        getTappedOperator(calcOperator: "/")
        getTappedDigit(digit: "1")
        getTappedDigit(digit: "0")
        
        getTappedCButton()
        
        XCTAssertEqual(formulaTxt, "24 /")
    }
    
    ///test RAZ
    func testGiven2020_WhenACButtonTapped_ThenRAZandDisplay0() {
        getTappedDigit(digit: "2")
        getTappedDigit(digit: "0")
        getTappedDigit(digit: "2")
        getTappedDigit(digit: "0")
        
        getTappedACButton()
        
        XCTAssertEqual(formulaTxt, "0")
    }
    
    ///test multi line screen with old result recovered on the new line after Plus tapped
    func testGiven2Plus4Egal6_WhenTappedPlus_ThenDisplayOldResultAndPlus () {
        getTappedDigit(digit: "2")
        getTappedOperator(calcOperator: "+")
        getTappedDigit(digit: "4")
        getTappedEqual()
        
        getTappedOperator(calcOperator: "+")
        
        XCTAssertEqual(formulaTxt, "2 + 4 = 6\n6 +")
    }
    
    ///test div/0 with notification flag
    func testGiven10Div0_WhenTappedEqual_ThenDisplay10Div0AndPopupError() {
        getTappedDigit(digit: "10")
        getTappedOperator(calcOperator: "/")
        getTappedDigit(digit: "0")
        
        getTappedEqual()
        
        XCTAssertEqual(formulaTxt, "10 / 0")
        XCTAssertTrue(didErrorDivByZero)
    }
    
    func testGiven_10PlusWhenTappedPlusTwice_ThenOnlyOneAppear() {
        getTappedDigit(digit: "10")
        getTappedOperator(calcOperator: "+")
        getTappedOperator(calcOperator: "+")
        
        XCTAssertEqual(formulaTxt, "10 +")
    }
    
    ///test formula not conform with notification flag
    func testGiven10Plus_WhenTappedEqual_ThenDisplay10Div0AndPopupError() {
        getTappedDigit(digit: "10")
        getTappedOperator(calcOperator: "+")
        getTappedEqual()
        
        XCTAssertEqual(formulaTxt, "10 +")
        XCTAssertTrue(didErrorFormula)
    }
}
