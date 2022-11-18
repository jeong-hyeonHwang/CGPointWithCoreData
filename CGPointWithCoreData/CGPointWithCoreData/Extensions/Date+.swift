//
//  Date+.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/19.
//

import Foundation

extension Date {
    func dateToString() -> String {
        let date = self.formatted(date: .numeric, time: .shortened)
        return String(date)
    }
}
