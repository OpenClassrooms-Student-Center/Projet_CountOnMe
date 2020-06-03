//
//  NotificationExtension.swift
//  CountOnMe
//
//  Created by Laurent Debeaujon on 03/06/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation
protocol ProcessingAlert {
    func errorNotification()
}
extension ProcessingAlert {
  
    func errorNotification() {
        let name = Notification.Name(rawValue: "CarryOutError")
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
}
