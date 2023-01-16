//
//  CGPoint+Hashable.swift
//  checkers
//
//  Created by Damian Wiśniewski on 16/01/2023.
//

import Foundation

extension CGPoint: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
