//
//  Strategist.swift
//  checkers
//
//  Created by Damian Wiśniewski on 23/01/2023.
//

import GameplayKit

struct Strategist {
    private let strategist: GKMinmaxStrategist = {
        let strategist = GKMinmaxStrategist()
        strategist.maxLookAheadDepth = 2
        strategist.randomSource = GKARC4RandomSource()
        return strategist
    }()
    
    var board: Board {
        didSet {
            strategist.gameModel = board
        }
    }
    
    var bestMove: Move? {
        if let move = strategist.bestMove(for: board.currentPlayer) as? Move {
            return move
        }
        
        return nil
    }
}

