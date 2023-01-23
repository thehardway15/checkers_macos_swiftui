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
    
    func searchBeat(for piece: Piece, next: CGPoint?) -> Move? {
        if piece.player == currentPlayer.opponent {
            if let nextFieldPos = next {
                let nextField = getField(at: nextFieldPos)
                if nextField == nil {
                    var checkMove: CGPoint? = nextFieldPos
                    var nextMove: Move? = nil
                    var beatCount = 0
                    
                    repeat {
                        let possibleBeatMove = possibleMoves(Piece(at: checkMove! , player: currentPlayer))
                        nextMove = possibleBeatMove.first { move in
                            move.beat != nil
                        }
                        checkMove = nextMove?.pos
                        beatCount+=1
                    } while nextMove != nil
                    
                    return Move(at: nextFieldPos, beat: piece, beatCount: beatCount)
                }
            }
        }
        
        return nil
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
            let move = searchBeat(for: fieldLeft, next: fieldLeft.backLeft())
            if let move = move {
                moves.append(move)
            }
        }
        
        if let fieldRight = fieldRight {
            let move = searchBeat(for: fieldRight, next: fieldRight.backRight())
            if let move = move {
                moves.append(move)
            }
        }
        
        // beat backwards
        // todo
        
        let max = moves.map { $0.beatCount }.max()
        
        moves = moves.filter({ move in
            move.beatCount == max
        })
        
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
            if move.beatCount <= 1 {
                currentPlayer = currentPlayer.opponent
                print("Change player to: \(currentPlayer.color)")
            }
        }
    }
}
