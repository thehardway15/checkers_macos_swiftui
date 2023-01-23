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
        VStack {
            HStack {
                Text("WHITE")
                    .padding(.horizontal)
                    .background(Capsule().fill(.gray).opacity(board.currentPlayer.playerType == .white ? 1 : 0))
                
                Spacer()
                
                Text("Checkers")
                
                Spacer()
                
                Text("RED")
                    .padding(.horizontal)
                    .background(Capsule().fill(.gray).opacity(board.currentPlayer.playerType == .black ? 1 : 0))

            }
            .font(.system(size: 36).weight(.bold))
            
            ZStack {
                Group {
                    Grid(horizontalSpacing:1, verticalSpacing: 1) {
                        ForEach(0..<boardSize, id: \.self) { row in
                            GridRow {
                                ForEach(0..<boardSize, id: \.self) { col in
                                    FieldView(col: col, row: row, board: board)
                                }
                            }
                        }
                    }
                }
                Group {
                    ForEach(0..<boardSize, id: \.self) { row in
                        ForEach(0..<boardSize, id: \.self) { col in
                            let piece = board.board.grid[row][col]
                            if piece != nil {
                                PieceView(piece: piece!, selectedPiece: $selectedPiece, board: board)
                            }
                        }
                        
                    }
                }
                
                if let winner = board.winner {
                    VStack {
                        Text("\(winner.playerType == .black ? "Red" : "White") wins!")
                            .font(.largeTitle)
                        
                        Button(action: board.reset) {
                            Text("Play Again")
                                .padding()
                                .background(.blue)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(40)
                    .background(.black.opacity(0.85))
                    .cornerRadius(25)
                    .transition(.scale)
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
