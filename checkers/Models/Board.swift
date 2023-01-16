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
    
    func possibleMoves(_ piece: Piece) -> [Move] {
        var moves: [Move] = []
        
        if currentPlayer.playerId == PlayerColor.white.rawValue {
            if piece.row - 1 >= 0 && piece.col - 1 >= 0 {
                let fieldLeft = grid[piece.row - 1][piece.col - 1]
                if fieldLeft == nil {
                    moves.append(Move(row: piece.row - 1, col: piece.col - 1))
                }
            }
            
            if piece.row - 1 >= 0 && piece.col + 1 < 8 {
                let fieldRight = grid[piece.row - 1][piece.col + 1]
                if fieldRight == nil {
                    moves.append(Move(row: piece.row - 1, col: piece.col + 1))
                }
            }
        } else {
            if piece.row + 1 < 8 && piece.col - 1 >= 0 {
                let fieldLeft = grid[piece.row + 1][piece.col - 1]
                if fieldLeft == nil {
                    moves.append(Move(row: piece.row + 1, col: piece.col - 1))
                }
            }
            
            if piece.row + 1 < 8 && piece.col + 1 < 8 {
                let fieldRight = grid[piece.row + 1][piece.col + 1]
                if fieldRight == nil {
                    moves.append(Move(row: piece.row + 1, col: piece.col + 1))
                }
            }
        }
        
        return moves
    }
    
    func canMove(_ piece: Piece, to position: CGPoint) -> Bool {
        let possibleMoves = possibleMoves(piece)
        let correctMove = possibleMoves.contains(where: { move in
            move.row == Int(position.y) && move.col == Int(position.x)
        })
        
        return correctMove
    }
    
    func move(_ piece: Piece, to position: CGPoint) {
        guard piece.player == currentPlayer else { return }
        guard canMove(piece, to: position) else { return }
        grid[piece.row][piece.col] = nil
        piece.position(position)
        grid[Int(position.y)][Int(position.x)] = piece
        currentPlayer = currentPlayer.opponent
    }
}
