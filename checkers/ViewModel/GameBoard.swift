//
//  GameBoard.swift
//  checkers
//
//  Created by Damian Wiśniewski on 15/01/2023.
//

import SwiftUI

class GameBoard: ObservableObject {
    var board: Board!
    
    init() {
        board = Board()
    }
    
    func move(_ piece: Piece, to position: CGPoint) {
        objectWillChange.send()
        
        board.move(piece, to: position)
    }
}
