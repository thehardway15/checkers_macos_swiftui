//
//  Move.swift
//  checkers
//
//  Created by Damian Wiśniewski on 16/01/2023.
//

import GameplayKit

class Move: NSObject, GKGameModelUpdate {
    var value: Int = 0
    
    var piece: Piece
    
    let row: Int
    let col: Int
    
    let beat: Piece?
    var beatCount: Int
    
    init(for piece: Piece, row: Int, col: Int) {
        self.piece = piece
        self.row = row
        self.col = col
        self.beat = nil
        self.beatCount = 0
    }
    
    init(for piece: Piece, at pos: CGPoint) {
        self.piece = piece
        self.row = Int(pos.y)
        self.col = Int(pos.x)
        self.beat = nil
        self.beatCount = 0
    }
    
    init(for piece: Piece, at pos: CGPoint, beat: Piece) {
        self.piece = piece
        self.row = Int(pos.y)
        self.col = Int(pos.x)
        self.beat = beat
        self.beatCount = 0
    }
    
    init(for piece: Piece, at pos: CGPoint, beat: Piece, beatCount: Int) {
        self.piece = piece
        self.row = Int(pos.y)
        self.col = Int(pos.x)
        self.beat = beat
        self.beatCount = beatCount
    }
    
    func setBeat(for beatCount: Int) {
        self.beatCount = beatCount
    }
    
    var pos: CGPoint {
       return CGPoint(x: col, y: row)
    }
    
    override var description: String {
        return "Move: \(row)/\(col) for \(piece.player.playerType) beat \(beat?.row)/\(beat?.col) beatCount \(beatCount)"
    }
}
