//
//  BoardView.swift
//  checkers
//
//  Created by Damian Wiśniewski on 15/01/2023.
//

import SwiftUI

struct BoardView: View {
    @StateObject private var board = GameBoard()
    @State private var selectedPiece: Piece?
    
    var body: some View {
        ZStack {
            Group {
                Grid(horizontalSpacing:1, verticalSpacing: 1) {
                    ForEach(0..<boardSize) { row in
                        GridRow {
                            ForEach(0..<boardSize) { col in
                                FieldView(col: col, row: row, board: board)
                            }
                        }
                    }
                }
            }
            Group {
                ForEach(0..<boardSize) { row in
                    ForEach(0..<boardSize) { col in
                        let piece = board.board.grid[row][col]
                        if piece != nil {
                            PieceView(piece: piece!, selectedPiece: $selectedPiece, board: board)
                        }
                    }
                    
                }
            }
        }
        .fixedSize()
        .preferredColorScheme(.dark)
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
