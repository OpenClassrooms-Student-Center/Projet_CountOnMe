//
//  SimpleCalcUITests.swift
//  SimpleCalcUITests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest

class SimpleCalcUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }
    
    func testButtons() {
        // Given
        let textView = app.textViews.element(boundBy: 0)
        
        // -------------------- Test 1 -------------------
        // When
        app.buttons["0"].tap()
        
        // Then
        if let textViewValue = textView.value as? String {
            XCTAssertEqual(textViewValue, "0")
        }
        
        // -------------------- Test 2 -------------------
        // When
        app.buttons["1"].tap()
        app.buttons["2"].tap()
        app.buttons["3"].tap()
        app.buttons["4"].tap()
        app.buttons["5"].tap()
        app.buttons["6"].tap()
        app.buttons["7"].tap()
        
        // Then
        if let textViewValue = textView.value as? String {
            XCTAssertEqual(textViewValue, "1234567")
        }
        
        // -------------------- Test 3 -------------------
        // When
        app.buttons["+"].tap()
        
        // Then
        if let textViewValue = textView.value as? String {
            XCTAssertEqual(textViewValue, "1234567 + ")
        }
        
        // -------------------- Test 4 -------------------
        // When
        app.buttons["-"].tap()
        
        // Then
        if let textViewValue = textView.value as? String {
            XCTAssertEqual(textViewValue, "1234567 - ")
        }
        
        // -------------------- Test 5 -------------------
        // When
        app.buttons["8"].tap()
        app.buttons["9"].tap()
        app.buttons["x"].tap()
        app.buttons["2"].tap()
        app.buttons["÷"].tap()
        app.buttons["2"].tap()
        app.buttons["0"].tap()
        
        // Then
        if let textViewValue = textView.value as? String {
            XCTAssertEqual(textViewValue, "1234567 - 89 x 2 ÷ 20")
        }
        
        // -------------------- Test 6 -------------------
        app.buttons["="].tap()
        
        // Then
        if let textViewValue = textView.value as? String {
            XCTAssertEqual(textViewValue, "1234567 - 89 x 2 ÷ 20 = 123447.8")
        }
        
        // -------------------- Test 7 -------------------
        app.buttons["AC"].tap()
        
        // Then
        if let textViewValue = textView.value as? String {
            XCTAssertEqual(textViewValue, "0")
        }
    }
}
