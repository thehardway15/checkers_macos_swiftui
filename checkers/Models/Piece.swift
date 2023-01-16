//
//  Piece.swift
//  checkers
//
//  Created by Damian Wiśniewski on 15/01/2023.
//

import SwiftUI

class Piece: Identifiable, Codable, Equatable {
    static func == (lhs: Piece, rhs: Piece) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }
    
    var id: String = UUID().uuidString
    var row: Int
    var col: Int
    var player: Player
    
    init(row: Int, col: Int, player: Player) {
        self.row = row
        self.col = col
        self.player = player
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case row
        case col
        case player
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        row = try values.decode(Int.self, forKey: .row)
        col = try values.decode(Int.self, forKey: .col)
        let playerId = try values.decode(Int.self, forKey: .player)
        player = Player.getById(id: PlayerColor(rawValue: playerId)!)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(row, forKey: .row)
        try container.encode(col, forKey: .col)
        try container.encode(player.playerId, forKey: .player)
    }
    
    func position(_ position: CGPoint) {
        row = Int(position.y)
        col = Int(position.x)
    }
    
    func copy() -> Piece {
        let piece = Piece(row: self.row, col: self.col, player: self.player)
        return piece
    }
}
