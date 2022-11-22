//
//  BodyPointInfo.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/20.
//

import Foundation

struct BodyPointInfo: Equatable {
    var footOrHand: FootOrHand
    var isForce: Bool
    var primaryPosition: CGPoint
    var secondaryPosition: CGPoint
}
