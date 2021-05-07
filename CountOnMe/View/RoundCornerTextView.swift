//
//  RoundCornerTextView.swift
//  CountOnMe
//
//  Created by Brian Friess on 04/05/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import UIKit

class RoundCornerTextView: UITextView {

    
    func setUpRoundButton(){
            layer.cornerRadius = 8
        }
    
    
    override func draw(_ rect: CGRect) {
        setUpRoundButton()
    }
}


