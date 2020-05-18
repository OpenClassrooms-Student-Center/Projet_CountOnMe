//
//  CalculatoreDelegateMockImplementation.swift
//  CountOnMe
//
//  Created by Elodie Desmoulin on 15/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

class CalculatoreDelegateMockImplementation: CalculatorDelegate {

    var operationStr: String?

    func operationStringDidUpdate(_ operation: String) {
        self.operationStr = operation
    }
}
