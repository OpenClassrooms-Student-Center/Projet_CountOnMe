//
//  Calculator.swift
//  CountOnMe
//
//  Created by Canessane Poudja on 15/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

protocol Calculator {
    var delegate: CalculatorDelegate? { get set }

    func add(number: Int)
    func add(mathOperator: MathOperator)
    func calculate() -> Float?
}
