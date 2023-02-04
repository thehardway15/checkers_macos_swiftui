//
//  Board.swift
//  checkers
//
//  Created by Damian Wiśniewski on 15/01/2023.
//

import GameplayKit

class Board: NSObject {
    public var grid = [[Piece?]]()
    public var currentPlayer: Player = Player.allPlayers[1]
    public var winner: Player? {
        let piecesCurrent = pieces(for: currentPlayer)
        if piecesForMove(piecesCurrent).isEmpty {
            return currentPlayer.opponent
        }
        
        let piecesOponent = pieces(for: currentPlayer.opponent)
        if piecesForMove(piecesOponent).isEmpty {
            return currentPlayer
        }
        
        return nil
    }
    
    override init() {
        super.init()
        setup()
    }
    
    func pieces(for player: Player) -> [Piece] {
        var pieces: [Piece] = []
        
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                let piece = getField(at: CGPoint(x: col, y: row))
                if piece?.player == player {
                    pieces.append(piece!)
                }
            }
        }
        
        return pieces
    }
    
    func setup() {
        currentPlayer = Player.allPlayers[1]
        grid.removeAll()
        for _ in 0..<boardSize {
            let newRow = Array<Piece?>(repeating: nil, count: 8)
            grid.append(newRow)
        }
        
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                if (col - row) % 2 != 0 && row != 3 && row != 4 {
                    let piece = Piece(row: row, col: col, player: row >= 5 ? Player.allPlayers[1] : Player.allPlayers[0])
                    grid[row][col] = piece
                }
            }
        }
        
//        grid[0][7] = Piece(row: 0, col: 7, player: Player.allPlayers[0])
//        grid[1][2] = Piece(row: 1, col: 2, player: Player.allPlayers[0])
//        grid[4][3] = Piece(row: 4, col: 3, player: Player.allPlayers[0])
//        var white = Piece(row: 7, col: 6, player: Player.allPlayers[1])
//        white.king = true
//
//        grid[7][6] = white

    }
    
    func getField(at pos: CGPoint) -> Piece? {
        return grid[Int(pos.y)][Int(pos.x)]
    }
    
    func canMove(_ piece: Piece, to position: CGPoint) -> Move? {
        if !piecesForMove(pieces(for: currentPlayer)).contains(piece) { return nil }
        let correctMove = piece.possibleMoves(grid: grid).first(where: { move in
            move.row == Int(position.y) && move.col == Int(position.x)
        })
        
        return correctMove
    }
    
    func piecesForMove(_ pieces: [Piece]) -> [Piece] {
        let maxBeat = pieces.map { piece in
            piece.possibleMoves(grid: grid).map { $0.beatCount }.max() ?? 0
        }.max() ?? 0
        
        return pieces.filter { piece in
            !piece.moveForBeatCount(on: grid, at: maxBeat).isEmpty
        }
    }
    
    func remove(_ piece: Piece) {
        grid[piece.row][piece.col] = nil
    }
    
    func apply(move: Move) {
        var gridLocal = grid
        gridLocal[move.piece.row][move.piece.col] = nil
        move.piece.position(move.pos)
        gridLocal[Int(move.pos.y)][Int(move.pos.x)] = move.piece
        if let oponentPiece = move.beat {
            gridLocal[Int(oponentPiece.row)][Int(oponentPiece.col)] = nil
        }
        
        grid = gridLocal
    }
    
    @discardableResult func move(_ piece: Piece, to position: CGPoint) -> Bool {
        guard piece.player == currentPlayer else { return false }
        var changePlayer = false
        if let move = canMove(piece, to: position) {
            apply(move: move)
            if move.beatCount <= 1 {
                currentPlayer = currentPlayer.opponent
                changePlayer = true
            }
        }
        piece.checkKing()
        
        return changePlayer
    }
}

extension Board: GKGameModel {
    var players: [GKGameModelPlayer]? {
        return Player.allPlayers
    }
    
    var activePlayer: GKGameModelPlayer? {
        return currentPlayer
    }
    
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        guard let player = player as? Player else {
            return nil
        }
        let pieces = pieces(for: player)
        let piecesForMove = piecesForMove(pieces)
        var moves = [Move]()
        
        piecesForMove.forEach { piece in
            piece.possibleMoves(grid: grid).forEach { move in
                moves.append(move)
            }
        }
        
        if isWin(for: player) {
            return nil
        }
        
        return moves
    }
    
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        guard let m = gameModelUpdate as? Move else { return }
        move(m.piece, to: m.pos)
    }
    
    func isWin(for player: GKGameModelPlayer) -> Bool {
        guard let player = player as? Player else {
            return false
        }
        
        let oponentPieces = pieces(for: player.opponent)
        
        if oponentPieces.isEmpty { return true }
        if piecesForMove(oponentPieces).isEmpty { return true }
        
        return false
    }
    
    func score(for player: GKGameModelPlayer) -> Int {
        guard let player = player as? Player else {
            return 0
        }
        
        if isWin(for: player) && player.playerType == .black { return 1 }
        return 0
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Board()
        copy.setGameModel(self)
        return copy
    }
    
    func setGameModel(_ gameModel: GKGameModel) {
        if let board = gameModel as? Board {
            grid.removeAll()
            for row in 0..<boardSize {
                var newRow = [Piece?]()
                
                for col in 0..<boardSize {
                    let piece = board.getField(at: CGPoint(x: col, y: row))
                    let cPiece = piece?.copy()
                    newRow.append(cPiece)
                }
                grid.append(newRow)
            }
        }
    }
    
    
}
