//
//  Date+.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/19.
//

import Foundation

extension Date {
    func dateToString() -> String {
        let date = self.formatted(date: .omitted, time: .complete)
        return String(date)
    }
    
    static func randomBetween(start: Date, end: Date) -> Date {
        var date1 = start
        var date2 = end
        if date2 < date1 {
            let temp = date1
            date1 = date2
            date2 = temp
        }
        let span = TimeInterval.random(in: date1.timeIntervalSinceNow...date2.timeIntervalSinceNow)
        return Date(timeIntervalSinceNow: span)
    }
}
