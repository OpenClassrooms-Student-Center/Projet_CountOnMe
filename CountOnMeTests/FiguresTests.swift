//
//  FiguresTests.swift
//  CountOnMeTests
//
//  Created by Laurent Debeaujon on 20/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import XCTest

@testable import CountOnMe

class FiguresTests: XCTestCase {
    var figure: Figures!
    var numberFormatter: NumberFormatter!
    
    var formula = [String]()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        figure = Figures()
        numberFormatter = NumberFormatter()
        
        self.numberFormatter.alwaysShowsDecimalSeparator = false
        self.numberFormatter.numberStyle = .decimal
        self.numberFormatter.maximumFractionDigits = 5
        self.numberFormatter.usesGroupingSeparator = true
        
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    ///test division
    func testGiven24Comma05Div5_WhenCarryOut_ThenResultEqual4Comma81() {
        formula.append(contentsOf: ["24,05", "/", "5"])
        
        let result = figure.carryOutFormula(formula: formula, numberFormatter: numberFormatter )!
        
        XCTAssertEqual(result, "4,81")
    }
    
    ///test multiplication operation with negative and float figure
    func testGivenMinus24Comma05Mult25Comma05_WhenCarryOut_ThenResultEqualMinus602Comma4525() {
        formula.append(contentsOf: ["-24,05", "x", "25,05"])
        
        let result = figure.carryOutFormula(formula: formula, numberFormatter: numberFormatter)!
        
        XCTAssertEqual(result, "-602,4525")
    }
    
    ///test soustraction
    func testGiven24500Minus10000_WhenCarryOut_ThenResultEqual14500() {
        formula.append(contentsOf: ["24 500", "-", "10 000"])
        
        let result = figure.carryOutFormula(formula: formula, numberFormatter: numberFormatter)
        
        XCTAssertEqual(result, "14 500")
    }
    
    ///test associativity in formula
    func testGiven5Plus100Mult2Minus200Div2_WhenCarryOut_ThenResult105() {
        formula.append(contentsOf: ["5", "+", "100", "x", "2", "-", "200", "/", "2"])
        
        let result = figure.carryOutFormula(formula: formula, numberFormatter: numberFormatter)
        
        XCTAssertEqual(result, "105")
    }
}
