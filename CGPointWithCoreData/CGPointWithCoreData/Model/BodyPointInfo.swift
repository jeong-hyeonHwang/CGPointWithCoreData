//
//  BodyPointInfo.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/20.
//

import Foundation

struct BodyPointInfo {
    var footOrHand: FootOrHand
    var isForce: Bool
    var primaryPostion: CGPoint
    var secondaryPositon: CGPoint?
}
