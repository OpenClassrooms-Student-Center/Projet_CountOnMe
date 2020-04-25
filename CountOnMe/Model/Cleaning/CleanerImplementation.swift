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

    // MARK: Properties

    weak var delegate: CleanerDelegate?

    // MARK: Methods

    ///Returns the given String without its last or 3 last characters if there is a space
    func clear(_ string: String) -> String {
        return string.last == " " ? String(string.dropLast(3)) : String(string.dropLast())
    }

    ///Returns an empty String
    func clearAll() -> String {
        return ""
    }
}
