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

class Piece: Identifiable, Codable, Equatable {
    static func == (lhs: Piece, rhs: Piece) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }
    
    var id: String = UUID().uuidString
    var row: Int
    var col: Int
    var player: Player
    var direction: PieceDirection
    
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
    
    enum CodingKeys: String, CodingKey {
        case id
        case row
        case col
        case player
        case direction
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        row = try values.decode(Int.self, forKey: .row)
        col = try values.decode(Int.self, forKey: .col)
        let directionRaw = try values.decode(String.self, forKey: .direction)
        direction = PieceDirection(rawValue: directionRaw)!
        let playerId = try values.decode(Int.self, forKey: .player)
        player = Player.getById(id: PlayerColor(rawValue: playerId)!)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(row, forKey: .row)
        try container.encode(col, forKey: .col)
        try container.encode(player.playerId, forKey: .player)
        try container.encode(direction.rawValue, forKey: .direction)
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
    
    func nextLeft() -> CGPoint? {
        let rowDirection = direction == .up ? -1 : 1
        
        if row + rowDirection >= 0 && col - 1 >= 0 && row + rowDirection < 8 && col - 1 < 8 {
            return CGPoint(x: col - 1, y: row + rowDirection)
        }
        return nil
    }
    
    func nextRight() -> CGPoint? {
        let rowDirection = direction == .up ? -1 : 1
        
        if row + rowDirection >= 0 && col + 1 >= 0 && row + rowDirection < 8 && col + 1 < 8{
            return CGPoint(x: col + 1, y: row + rowDirection)
        }
        return nil
    }
    
    func backLeft() -> CGPoint? {
        let rowDirection = direction == .up ? 1 : -1
        
        if row + rowDirection >= 0 && col - 1 >= 0 && row + rowDirection < 8 && col - 1 < 8{
            return CGPoint(x: col - 1, y: row + rowDirection)
        }
        return nil
    }
    
    func backRight() -> CGPoint? {
        let rowDirection = direction == .up ? 1 : -1
        
        if row + rowDirection >= 0 && col + 1 >= 0 && row + rowDirection < 8 && col + 1 < 8{
            return CGPoint(x: col + 1, y: row + rowDirection)
        }
        return nil
    }
}
