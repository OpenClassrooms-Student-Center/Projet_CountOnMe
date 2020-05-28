//
//  CalcFormatterTestsExtensionDelegate.swift
//  CountOnMeTests
//
//  Created by Laurent Debeaujon on 24/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

// MARK: calcFormatterDelegate in ClacFormatterTests
extension CalcFormatterTests: CalcFormatterDelegate {
    func didRefreshScreenResult(screen: String) {
         print("****\(screen)****")
         formulaTxt = screen
     }
}
