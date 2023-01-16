//
//  GameBoard.swift
//  checkers
//
//  Created by Damian Wiśniewski on 15/01/2023.
//

import SwiftUI

class GameBoard: ObservableObject {
    var board: Board!
    private var frames: [CGPoint: CGRect] = [:]
    
    init() {
        board = Board()
    }
    
    func update(frame: CGRect, for id: CGPoint) {
        frames[id] = frame
    }
    
    func update(for piece: Piece, where position: CGPoint) {
        for (id, frame) in frames where frame.contains(position) {
            move(piece, to: id)
        }
    }
    
    func move(_ piece: Piece, to position: CGPoint) {
        objectWillChange.send()
        
        board.move(piece, to: position)
    }
}

extension CGPoint: Hashable {
    public var hashValue: Int {
        //This expression can be any of the arbitrary expression which fulfills the axiom above.
        return x.hashValue ^ y.hashValue
    }
}
