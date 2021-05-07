//
//  RoundCorner.swift
//  CountOnMe
//
//  Created by Brian Friess on 03/05/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import UIKit

class RoundCornerNumber: UIStackView {

    @IBOutlet private var roundButton : [UIButton]!
    

    func setUpRoundButton(){
        for i in 0...roundButton.count-1{
            roundButton[i].layer.cornerRadius = 10
        }
    }
    
    override func draw(_ rect: CGRect) {
        setUpRoundButton()
    }

}
