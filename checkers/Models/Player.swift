//
//  Player.swift
//  checkers
//
//  Created by Damian Wiśniewski on 15/01/2023.
//

import GameplayKit
import SwiftUI

enum PlayerColor: Int {
    case black = 0, white
}

class Player: NSObject, GKGameModelPlayer {
    var playerId: Int
    var color: Color
    
    static var allPlayers: [Player] = [Player(.black), Player(.white)]
    
    init(_ playerId: PlayerColor) {
        self.playerId = playerId.rawValue
        self.color = playerId.rawValue == 0 ? .red : .white
    }
    
    var opponent: Player {
        if playerId == PlayerColor.black.rawValue {
            return Player.allPlayers[1]
        } else {
            return Player.allPlayers[0]
        }
    }
    
    static func getById(id: PlayerColor) -> Player {
        return id == .black ? Player.allPlayers[0] : Player.allPlayers[1]
    }
}
