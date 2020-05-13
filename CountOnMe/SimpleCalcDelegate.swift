//
//  SimpleCalcDelegate.swift
//  CountOnMe
//
//  Created by Laurent Debeaujon on 12/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation
protocol SimpleCalcDelegate: AnyObject {
    func didDataProcessing(elements: [String]) -> [String]
}
