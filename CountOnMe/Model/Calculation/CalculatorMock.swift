//
//  CalculatorMock.swift
//  CountOnMe
//
//  Created by Canessane Poudja on 24/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

class CalculatorDelegateMock: CalculatorDelegate {

    // MARK: - INTERNAL

    // MARK: Properties

    ///Equals to CalculatorImplementation's textToCompute
    var operationString: String = ""

    ///Equals to CalculatorImplementation's result
    var result: Float = 0

    // MARK: Methods

    ///Assigns the value of the given String to operationString
    func didUpdateTextToCompute(text: String) {
        operationString = text
    }

    ///Assigns the value of the given Float to result
    func didUpdateResult(number: Float) {
        result = number
    }
}
