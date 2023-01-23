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
    var beatCount: Int
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
        self.beat = nil
        self.beatCount = 0
    }
    
    init(at pos: CGPoint) {
        self.row = Int(pos.y)
        self.col = Int(pos.x)
        self.beat = nil
        self.beatCount = 0
    }
    
    init(at pos: CGPoint, beat: Piece) {
        self.row = Int(pos.y)
        self.col = Int(pos.x)
        self.beat = beat
        self.beatCount = 0
    }
    
    init(at pos: CGPoint, beat: Piece, beatCount: Int) {
        self.row = Int(pos.y)
        self.col = Int(pos.x)
        self.beat = beat
        self.beatCount = beatCount
    }
    
    mutating func setBeat(for beatCount: Int) {
        self.beatCount = beatCount
    }
    
    var pos: CGPoint {
       return CGPoint(x: col, y: row)
    }
}
