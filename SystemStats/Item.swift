//
//  Item.swift
//  SystemStats
//
//  Created by Zach Nagengast on 11/9/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
