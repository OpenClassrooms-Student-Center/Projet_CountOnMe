//
//  CleanerImplementation.swift
//  CountOnMe
//
//  Created by Canessane Poudja on 19/04/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

class CleanerImplementation: Cleaner {
    var delegate: CleanerDelegate?
    
    func clear(_ string: String) -> String  {
        return string.last == " " ? String(string.dropLast(3)) : String(string.dropLast())
    }

    func clearAll() -> String {
        return ""
    }
    
}
