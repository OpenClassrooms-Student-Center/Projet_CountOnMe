//
//  Cleaning.swift
//  CountOnMe
//
//  Created by Canessane Poudja on 19/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

protocol Cleaner {

    func clearLastElement(of string: String) -> String
    func clearAll() -> String
}
