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
    
    var body: some View {
        Circle()
            .foregroundStyle(
                piece.player.color.gradient.shadow(
                    .inner(color: .black.opacity(0.8), radius: 2, x: -2, y: -2)
                )
            )
            .frame(width: pieceSize, height: pieceSize)
            .shadow(radius: 5, x: 5, y: 5)
            .offset(offset)
            .zIndex(selectedPiece == piece ? 3 : 2)
            .position(x: CGFloat(piece.col) * (fieldSize + 1) + 32, y: CGFloat(piece.row) * (fieldSize + 1) + 32)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.offset = value.translation
                        self.selectedPiece = piece
                    }
                    .onEnded { value in
                        self.offset = .zero
                        self.selectedPiece = nil
                        self.movePiece(to: value.location)
                    }
            )
    }
    
    func movePiece(to location: CGPoint) {
        // Update the board state based on the piece's new location
    }
}
