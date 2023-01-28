//
//  GameBoard.swift
//  checkers
//
//  Created by Damian Wiśniewski on 15/01/2023.
//

import SwiftUI

class GameBoard: ObservableObject {
    var board: Board!
    var strategist: Strategist!
    
    private var frames: [CGPoint: CGRect] = [:]
    public var winner: Player? {
        return board.winner
    }
    var currentPlayer: Player {
        return board.currentPlayer
    }
    
    init() {
        board = Board()
        strategist = Strategist(board: board)
        strategist.board = board
    }
    
    func reset() {
        objectWillChange.send()
        strategist = Strategist(board: board)
        board.setup()
        
        strategist.board = board
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
        let changePlayer = board.move(piece, to: position)
        if currentPlayer.playerType == .black {
            processAIMove()
        }
        print(currentPlayer.playerType)
    }
    
    func processAIMove() {
        print("Process AI")
        
        DispatchQueue.global().async {
            let strategistTime = CFAbsoluteTime()
            guard let bestMove = self.strategist.bestMove else {
                print("not best move")
                return
            }
            
            let delta = CFAbsoluteTime() - strategistTime
            let aiTimeCeilling = 0.75
            let delay = max(delta, aiTimeCeilling)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                print("Best move: row \(bestMove.row) col \(bestMove.col) beatCount \(bestMove.beatCount) \(bestMove.piece.player.playerType)")
                self.move(bestMove.piece, to: bestMove.pos)
            }
        }
    }
}

