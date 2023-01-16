//
//  Board.swift
//  checkers
//
//  Created by Damian Wiśniewski on 15/01/2023.
//

import Foundation

class Board: NSObject {
    public var grid = [[Piece?]]()
    public var currentPlayer: Player = Player.allPlayers[1]
    
    override init() {
        super.init()
        setup()
    }
    
    func setup() {
        currentPlayer = Player.allPlayers[1]
        grid.removeAll()
        
        for row in 0..<boardSize {
            var newRow = [Piece?]()
            
            for col in 0..<boardSize {
                if (col - row) % 2 != 0 && row != 3 && row != 4 {
                    var piece = Piece(row: row, col: col, player: row >= 5 ? Player.allPlayers[1] : Player.allPlayers[0])
                    newRow.append(piece)
                } else {
                    newRow.append(nil)
                }
            }
            
            grid.append(newRow)
        }
    }
    
    func move(_ piece: Piece, to position: CGPoint) {
        guard piece.player == currentPlayer else { return }
        piece.position(position)
    }
}
