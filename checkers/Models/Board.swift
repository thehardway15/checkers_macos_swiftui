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
                    let piece = Piece(row: row, col: col, player: row >= 5 ? Player.allPlayers[1] : Player.allPlayers[0])
                    newRow.append(piece)
                } else {
                    newRow.append(nil)
                }
            }
            
            grid.append(newRow)
        }
    }
    
    func getField(at pos: CGPoint) -> Piece? {
        return grid[Int(pos.y)][Int(pos.x)]
    }
    
    func possibleMoves(_ piece: Piece) -> [Move] {
        var moves: [Move] = []
        
        // Simple piece move forward
        
        let leftPos = piece.nextLeft()
        let rightPos = piece.nextRight()
        var fieldLeft: Piece? = nil
        var fieldRight: Piece? = nil
        
        if let leftPos = leftPos {
            fieldLeft = getField(at: leftPos)
            if fieldLeft == nil {
                moves.append(Move(at: leftPos))
            }
        }
        
        if let rightPos = rightPos {
            fieldRight = getField(at: rightPos)
            if fieldRight == nil {
                moves.append(Move(at: rightPos))
            }
        }
        
        // Simple piece beat opponent
        
        if let fieldLeft = fieldLeft {
            if fieldLeft.player == currentPlayer.opponent {
                let nextFieldPos = fieldLeft.backLeft()
                if let nextFieldPos = nextFieldPos {
                    let nextField = getField(at: nextFieldPos)
                    if nextField == nil {
                        moves.append(Move(at: nextFieldPos, beat: fieldLeft))
                    }
                }
            }
        }
        
        if let fieldRight = fieldRight {
            if fieldRight.player == currentPlayer.opponent {
                let nextFieldPos = fieldRight.backRight()
                if let nextFieldPos = nextFieldPos {
                    let nextField = getField(at: nextFieldPos)
                    if nextField == nil {
                        moves.append(Move(at: nextFieldPos, beat: fieldRight))
                    }
                }
            }
        }
        
        return moves
    }
    
    func canMove(_ piece: Piece, to position: CGPoint) -> Move? {
        let possibleMoves = possibleMoves(piece)
        let correctMove = possibleMoves.first(where: { move in
            move.row == Int(position.y) && move.col == Int(position.x)
        })
        
        return correctMove
    }
    
    func remove(_ piece: Piece) {
        grid[piece.row][piece.col] = nil
    }
    
    func move(_ piece: Piece, to position: CGPoint) {
        guard piece.player == currentPlayer else { return }
        if let move = canMove(piece, to: position) {
            remove(piece)
            piece.position(position)
            grid[Int(position.y)][Int(position.x)] = piece
            if let oponentPiece = move.beat {
                remove(oponentPiece)
            }
            currentPlayer = currentPlayer.opponent
        }
    }
}
