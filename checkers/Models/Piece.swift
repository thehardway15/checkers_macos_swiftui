//
//  Piece.swift
//  checkers
//
//  Created by Damian Wiśniewski on 15/01/2023.
//

import SwiftUI

enum PieceDirection: String {
    case up
    case down
    case both
}

class Piece: Equatable {
    static func == (lhs: Piece, rhs: Piece) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }
    
    var row: Int
    var col: Int
    var player: Player
    var direction: PieceDirection
    var king: Bool = false
    
    func checkKing() {
        if !king {
            if player.playerType == .white && row == 0 {
                king = true
            }
            
            if player.playerType == .black && row == 8 {
                king = true
            }
        }
    }
    
    init(row: Int, col: Int, player: Player) {
        self.row = row
        self.col = col
        self.player = player
        self.direction = player.playerId == PlayerColor.black.rawValue ? .down : .up
    }
    
    init(at pos: CGPoint, player: Player) {
        self.row = Int(pos.y)
        self.col = Int(pos.x)
        self.player = player
        self.direction = player.playerId == PlayerColor.black.rawValue ? .down : .up
    }
    
    func position(_ position: CGPoint) {
        row = Int(position.y)
        col = Int(position.x)
    }
    
    var pos: CGPoint {
       return CGPoint(x: col, y: row)
    }
    
    func copy() -> Piece {
        let piece = Piece(row: self.row, col: self.col, player: self.player)
        return piece
    }
    
    func nextLeft(step: Int = 1) -> CGPoint? {
        let rowDirection = direction == .up ? -1 : 1
        
        let x = col - (1 * step)
        let y = row + (rowDirection * step)
        
        if y >= 0 && x >= 0 && y < 8 && x < 8 {
            return CGPoint(x: x, y: y)
        }
        return nil
    }
    
    func nextRight(step: Int = 1) -> CGPoint? {
        let rowDirection = direction == .up ? -1 : 1
        
        let x = col + (1 * step)
        let y = row + (rowDirection * step)
        
        if y >= 0 && x >= 0 && y < 8 && x < 8 {
            return CGPoint(x: x, y: y)
        }
        return nil
    }
    
    func backLeft(step: Int = 1) -> CGPoint? {
        let rowDirection = direction == .up ? 1 : -1
        
        let x = col - (1 * step)
        let y = row + (rowDirection * step)
        
        if y >= 0 && x >= 0 && y < 8 && x < 8 {
            return CGPoint(x: x, y: y)
        }
        return nil
    }
    
    func backRight(step: Int = 1) -> CGPoint? {
        let rowDirection = direction == .up ? 1 : -1
        
        let x = col + (1 * step)
        let y = row + (rowDirection * step)
        
        if y >= 0 && x >= 0 && y < 8 && x < 8 {
            return CGPoint(x: x, y: y)
        }
        return nil
    }
    
    func getField(grid: [[Piece?]], at pos: CGPoint) -> Piece? {
        return grid[Int(pos.y)][Int(pos.x)]
    }
    
    func apply(_ move: Move, on grid: [[Piece?]]) -> [[Piece?]] {
        var gridLocal = grid.map { $0 }
        gridLocal[move.piece.row][move.piece.col] = nil
        move.piece.position(move.pos)
        gridLocal[Int(move.pos.y)][Int(move.pos.x)] = move.piece
        if let oponentPiece = move.beat {
            gridLocal[Int(oponentPiece.row)][Int(oponentPiece.col)] = nil
        }
        
        return gridLocal
    }
    
    func checkBeat(grid: [[Piece?]], beatCount: Int, next: (Int) -> CGPoint?) -> Move? {
        let nextPos = next(1)
        if let nextPos = nextPos, let field = getField(grid: grid, at: nextPos) {
            if field.player == player.opponent {
                if let posAfterPiece = next(2) {
                    if getField(grid: grid, at: posAfterPiece) == nil {
                        return Move(for: self, at: posAfterPiece, beat: field, beatCount: beatCount + 1)
                    }
                }
            }
        }
        return nil
    }
    
    func checkKingBeat(grid: [[Piece?]], beatCount: Int, next: (Int) -> CGPoint?) -> [Move] {
        var moves: [Move] = []
        
        var field: Piece? = nil
        var emptyField: Piece? = nil
        var step = 0
        
        var pos: CGPoint? = nil
        repeat {
            step += 1
            pos = next(step)
            if pos != nil {
                field = getField(grid: grid, at: pos!)
            }
        } while pos != nil && field == nil
        
        if pos != nil && field != nil && field?.player != self.player {
            repeat {
                step += 1
                pos = next(step)
                if pos != nil {
                    emptyField = getField(grid: grid, at: pos!)
                    if emptyField == nil {
                        moves.append(Move(for: self, at: pos!, beat: field!, beatCount: beatCount + 1))
                    }
                }
            } while pos != nil && emptyField == nil
        }
        
        return moves
    }
    
    func possibleKingBeatMove(grid: [[Piece?]], beatCount: Int = 0) -> [Move] {
        var moves: [Move] = []
        
        checkKingBeat(grid: grid, beatCount: beatCount, next: nextLeft).forEach { move in moves.append(move) }
        checkKingBeat(grid: grid, beatCount: beatCount, next: nextRight).forEach { move in moves.append(move) }
        checkKingBeat(grid: grid, beatCount: beatCount, next: backLeft).forEach { move in moves.append(move) }
        checkKingBeat(grid: grid, beatCount: beatCount, next: backRight).forEach { move in moves.append(move) }
        
        debugPrint(moves)
        
        let oldPos = pos
        
        moves.forEach { move in
            let newGrid = apply(move, on: grid)
            let nextMoves = possibleKingBeatMove(grid: newGrid, beatCount: beatCount + 1)
            let max = nextMoves.map { $0.beatCount }.max()
            if let max = max{
                if max > move.beatCount {
                    move.beatCount = max
                }
            }
        }
        
        position(oldPos)
        
        return moves
    }
    
    func possibleBeatMove(grid: [[Piece?]], beatCount: Int = 0) -> [Move] {
        var moves: [Move] = []
        
        if let move = checkBeat(grid: grid, beatCount: beatCount, next: nextLeft) { moves.append(move) }
        if let move = checkBeat(grid: grid, beatCount: beatCount, next: nextRight) { moves.append(move) }
        if let move = checkBeat(grid: grid, beatCount: beatCount, next: backLeft) { moves.append(move) }
        if let move = checkBeat(grid: grid, beatCount: beatCount, next: backRight) { moves.append(move) }
        
        let oldPos = pos
        
        moves.forEach { move in
            let newGrid = apply(move, on: grid)
            let nextMoves = possibleBeatMove(grid: newGrid, beatCount: beatCount + 1)
            let max = nextMoves.map { $0.beatCount }.max()
            if let max = max{
                if max > move.beatCount {
                    move.beatCount = max
                }
            }
        }
        
        position(oldPos)
        
        return moves
    }
    
    func possibleNormalMove(grid: [[Piece?]]) -> [Move] {
        var moves: [Move] = []
        // Simple piece move forward
        
        let leftPos = nextLeft()
        let rightPos = nextRight()
        var fieldLeft: Piece? = nil
        var fieldRight: Piece? = nil
        
        
        //MARK: - Move forwart regular piece
        
        if let leftPos = leftPos {
            fieldLeft = getField(grid: grid, at: leftPos)
            if fieldLeft == nil {
                moves.append(Move(for: self, at: leftPos))
            }
        }
        
        if let rightPos = rightPos {
            fieldRight = getField(grid: grid, at: rightPos)
            if fieldRight == nil {
                moves.append(Move(for: self, at: rightPos))
            }
        }
        
        return moves
    }
    
    func possibleMoves(grid: [[Piece?]]) -> [Move] {
        var moves: [Move] = []
        
        //MARK: - Normal move
        if king {
            moves += possibleKingNormalMoves(grid: grid)
        } else {
            moves += possibleNormalMove(grid: grid)
        }
        
        //MARK: - Beat search
        if king {
            moves += possibleKingBeatMove(grid: grid)
        } else {
            moves += possibleBeatMove(grid: grid)
        }
        
        //MARK: - filter only max beat count for piece
        
        let max = moves.map { $0.beatCount }.max()
        
        moves = moves.filter({ move in
            move.beatCount == max
        })
        
        return moves
    }
    
    func searchCrossLineMove(grid: [[Piece?]], next: (Int) -> CGPoint?) -> [Move] {
        var moves: [Move] = []
        
        var field: Piece? = nil
        var step = 0
        
        var pos: CGPoint? = nil
        repeat {
            step += 1
            pos = next(step)
            if pos != nil {
                field = getField(grid: grid, at: pos!)
                if field == nil {
                    moves.append(Move(for: self, at: pos!))
                }
            }
        } while pos != nil && field == nil
       
        return moves
    }
    
    func possibleKingNormalMoves(grid: [[Piece?]]) -> [Move] {
        var moves: [Move] = []
        
        moves += searchCrossLineMove(grid: grid, next: nextLeft)
        moves += searchCrossLineMove(grid: grid, next: nextRight)
        moves += searchCrossLineMove(grid: grid, next: backLeft)
        moves += searchCrossLineMove(grid: grid, next: backRight)
        
        return moves
    }
    
    func moveForBeatCount(on grid: [[Piece?]], at maxBeat: Int) -> [Move] {
        let moves = possibleMoves(grid: grid)
        return moves.filter { $0.beatCount == maxBeat }
    }
}
