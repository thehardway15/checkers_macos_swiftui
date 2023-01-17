//
//  Move.swift
//  checkers
//
//  Created by Damian Wiśniewski on 16/01/2023.
//

import Foundation

struct Move {
    let row: Int
    let col: Int
    
    let beat: Piece?
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
        self.beat = nil
    }
    
    init(at pos: CGPoint) {
        self.row = Int(pos.y)
        self.col = Int(pos.x)
        self.beat = nil
    }
    
    init(at pos: CGPoint, beat: Piece) {
        self.row = Int(pos.y)
        self.col = Int(pos.x)
        self.beat = beat
    }
}
