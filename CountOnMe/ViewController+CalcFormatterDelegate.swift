//
//  ViewControlerExtensionDelegate.swift
//  CountOnMe
//
//  Created by Laurent Debeaujon on 24/05/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

extension ViewController: CalcFormatterDelegate {
    // MARK: calcFormatterDelegate in ViewController
    func didRefreshHistoryResult(screen: String) {
        textView.text = screen
    }
}
