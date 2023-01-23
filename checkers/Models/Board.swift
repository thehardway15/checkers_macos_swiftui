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
    public var winner: Player? {
        if piecesForMove().isEmpty {
            return currentPlayer.opponent
        }
        
        return nil
    }
    
    var pieces: [Piece] {
        var pieces: [Piece] = []
        
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                let piece = getField(at: CGPoint(x: col, y: row))
                if piece?.player == currentPlayer {
                    pieces.append(piece!)
                }
            }
        }
        
        return pieces
    }
    
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
        setMoveForPieces()
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
                        let possibleBeatMove = possibleMoves(Piece(at: checkMove!, player: currentPlayer))
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
        let leftBackPos = piece.backLeft()
        let rightBackPos = piece.backRight()
        
        var fieldLeft: Piece? = nil
        var fieldRight: Piece? = nil
        var fieldBackLeft: Piece? = nil
        var fieldBackRight: Piece? = nil
        
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
        if let leftBackPos = leftBackPos {
            fieldBackLeft = getField(at: leftBackPos)
        }
        
        if let fieldBackLeft = fieldBackLeft {
            let move = searchBeat(for: fieldBackLeft, next: fieldBackLeft.nextLeft())
            if let move = move {
                moves.append(move)
            }
        }
        
        if let rightBackPos = rightBackPos {
            fieldBackRight = getField(at: rightBackPos)
        }
        
        if let fieldBackRight = fieldBackRight {
            let move = searchBeat(for: fieldBackRight, next: fieldBackRight.nextRight())
            if let move = move {
                moves.append(move)
            }
        }
        
        let max = moves.map { $0.beatCount }.max()
        
        moves = moves.filter({ move in
            move.beatCount == max
        })
        
        return moves
    }
    
    func canMove(_ piece: Piece, to position: CGPoint) -> Move? {
        let correctMove = piece.possibleMoves.first(where: { move in
            move.row == Int(position.y) && move.col == Int(position.x)
        })
        
        return correctMove
    }
    
    func setMoveForPieces() {
        pieces.forEach({ piece in
            piece.possibleMoves = possibleMoves(piece)
        })
        
        let maxBeat = pieces.map { piece in
            piece.possibleMoves.map { $0.beatCount }.max() ?? 0
        }.max()
        
        pieces.forEach { piece in
            piece.possibleMoves = piece.possibleMoves.filter { $0.beatCount == maxBeat }
        }
    }
    
    func piecesForMove() -> [Piece] {
        return pieces.filter { piece in
            !piece.possibleMoves.isEmpty
        }
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
            setMoveForPieces()
        }
    }
}
