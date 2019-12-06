//
//  DateUtils.swift
//  clipboard
//
//  Created by wyy on 2019/12/6.
//  Copyright © 2019 yahaha. All rights reserved.
//

import Foundation

extension Date {
    func elapsedString() -> String {
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        dateComponentsFormatter.unitsStyle = .full
        return dateComponentsFormatter.string(from: self, to: Date()) ?? ""
    }
    
    func elapsedEssentially() -> (n: Int, unit: NSCalendar.Unit)? {
        let seconds = self.timeIntervalSince1970.distance(to: Date().timeIntervalSince1970)
        if seconds < 0 {
            return (-1, .second)
        }
        let minutes = seconds / 60
        if minutes < 1 {
            return (Int(seconds), .second)
        }
        let hour = minutes / 60
        if hour < 1 {
            return (Int(minutes), .minute)
        }
        let d = hour / 24
        if d < 1 {
            return (Int(hour), .hour)
        }
        let month = d / 30
        if d < 1 {
            return (Int(month), .day)
        }
        return nil
    }
    
    func toLocalString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.identifier)
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.medium
        return formatter.string(from: self)
    }
}
