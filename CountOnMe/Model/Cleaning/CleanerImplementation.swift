//
//  CleanerImplementation.swift
//  CountOnMe
//
//  Created by Canessane Poudja on 19/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

class CleanerImplementation: Cleaner {

    // MARK: - INTERNAL

    // MARK: Methods

    ///Returns the given String without its last or 3 last characters if there is a space
    func clearLastElement(of string: String) -> String {
        return string.last == " " ? String(string.dropLast(3)) : String(string.dropLast())
    }

    ///Returns an empty String
    func clearAll() -> String {
        return ""
    }
}
