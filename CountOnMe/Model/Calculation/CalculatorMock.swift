//
//  CalculatorMock.swift
//  CountOnMe
//
//  Created by Canessane Poudja on 24/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

class CalculatorDelegateMock: CalculatorDelegate {
    var operationString: String = ""
    var result: Float = 0
    
    func didUpdateTextToCompute(text: String) {
        operationString = text
    }

    func didUpdateResult(number: Float) {
        result = number
    }
}
