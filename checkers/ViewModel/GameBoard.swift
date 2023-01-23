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
    public var winner: Player? {
        return board.winner
    }
    public var currentPlayer: Player {
        return board.currentPlayer
    }
    
    init() {
        board = Board()
    }
    
    func reset() {
        
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

