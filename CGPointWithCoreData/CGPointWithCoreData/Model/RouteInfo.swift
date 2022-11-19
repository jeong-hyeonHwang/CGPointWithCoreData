//
//  RouteInfo.swift
//  CGPointWithCoreData
//
//  Created by 황정현 on 2022/11/19.
//

import Foundation

struct RouteInfo {
    var dataWrittenDate: Date
    var gymName: String
    var problemLevel: Int
    var isChallengeComplete: Bool
    var pages: [PageInfo]
}
