//
//  PieceView.swift
//  checkers
//
//  Created by Damian Wiśniewski on 15/01/2023.
//

import SwiftUI

struct PieceView: View {
    @State private var offset: CGSize = .zero
    let piece: Piece
    @Binding var selectedPiece: Piece?
    private let offsetPosition: CGFloat = 32.0
    private let offsetSpacing: CGFloat = 1.0
    @ObservedObject var board: GameBoard
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(
                    piece.player.color.gradient.shadow(
                        .inner(color: .black.opacity(0.8), radius: 2, x: -2, y: -2)
                    )
                )
                .frame(width: pieceSize, height: pieceSize)
                .shadow(radius: 5, x: 5, y: 5)
            
            if piece.king {
                Image(systemName: "crown")
                    .foregroundColor(.black)
            }
        }
        .offset(offset)
        .zIndex(selectedPiece == piece ? 3 : 2)
        .position(x: CGFloat(piece.col) * (fieldSize + offsetSpacing) + offsetPosition, y: CGFloat(piece.row) * (fieldSize + offsetSpacing) + offsetPosition)
        .gesture(
            DragGesture(coordinateSpace: .global)
                .onChanged { value in
                    if board.currentPlayer.playerType == .white {
                        self.offset = value.translation
                        self.selectedPiece = piece
                    }
                }
                .onEnded { value in
                    if board.currentPlayer.playerType == .white {
                        self.offset = .zero
                        self.selectedPiece = nil
                        self.movePiece(to: value.location)
                    }
                }
        )
    }
    
    func movePiece(to location: CGPoint) {
        board.update(for: piece, where: location)
    }
}
